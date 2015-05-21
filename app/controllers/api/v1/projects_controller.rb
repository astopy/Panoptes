class Api::V1::ProjectsController < Api::ApiController
  include FilterByOwner
  include FilterByCurrentUserRoles
  include TranslatableResource

  doorkeeper_for :update, :create, :destroy, :create_export, scopes: [:project]
  resource_actions :default
  schema_type :json_schema

  alias_method :project, :controlled_resource

  CONTENT_PARAMS = [:description,
                    :title,
                    :science_case,
                    :introduction,
                    :faq,
                    :education_content,
                    :result,
                    team_members: [:name, :bio, :twitter, :institution],
                    guide: [:image, :explanation]]

  CONTENT_FIELDS = [:title,
                    :description,
                    :guide,
                    :faq,
                    :education_content,
                    :result,
                    :team_members,
                    :science_case,
                    :introduction,
                    :url_labels]


  before_action :add_owner_ids_to_filter_param!, only: :index
  prepend_before_action :require_login, only: [:create, :update, :destroy, :create_export]

  def create_export
    media_create_params = params.require(:media).permit(:content_type)
    medium = controlled_resource.classifications_exports.create!(media_create_params)
    ClassificationsDumpWorker.perform_async(controlled_resource.id, medium.id)
    headers['Location'] = "#{request.protocol}#{request.host_with_port}/api/projects/#{controlled_resource.id}/classifications_exports/#{medium.id}"
    headers['Last-Modified'] = medium.updated_at.httpdate
    json_api_render(:created, MediumSerializer.resource({}, Medium.where(id: medium.id)))
  end

  private

  def create_response(projects)
    serializer.resource({ include: 'owners' },
                        resource_scope(projects),
                        fields: CONTENT_FIELDS)
  end

  def content_from_params(ps)
    ps[:title] = ps[:display_name]
    content = ps.slice(*CONTENT_FIELDS)
    content[:language] = ps[:primary_language]
    if ps.has_key? :urls
      urls, labels = extract_url_labels(ps[:urls])
      content[:url_labels] = labels
      ps[:urls] = urls
    end
    ps.except!(*CONTENT_FIELDS)
    content.select { |k,v| !!v }
  end

  def build_resource_for_create(create_params)
    allowed_to_approve
    create_params[:project_contents] = [ProjectContent.new(content_from_params(create_params))]
    add_user_as_linked_owner(create_params)
    super(create_params)
  end

  def build_update_hash(update_params, id)
    allowed_to_approve
    content_update = content_from_params(update_params)
    unless content_update.blank?
      Project.find(id).primary_content.update!(content_update)
    end
    super(update_params, id)
  end

  def allowed_to_approve
    raise Api::UnpermittedParameter, "Only Admins may Approve Projects" if create_params.has_key?(:approved) && !api_user.is_admin?
  end

  def new_items(resource, relation, value)
    super(resource, relation, value).map do |object|
      object.dup.tap do |dup_object|
        if dup_object.is_a?(Workflow)
          dup_object.workflow_contents = object.workflow_contents.map(&:dup)
        end
      end
    end
  end

  def extract_url_labels(urls)
    visitor = TasksVisitors::ExtractStrings.new
    visitor.visit(urls)
    [urls, visitor.collector]
  end

  def context
    case action_name
    when "show", "index"
      { languages: current_languages, fields: CONTENT_FIELDS }
    else
      { fields: CONTENT_FIELDS }
    end
  end
end
