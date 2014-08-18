class Collection < ActiveRecord::Base
  include RoleControl::Controlled
  include RoleControl::Ownable
  include RoleControl::Adminable
  include Activatable
  
  attr_accessible :name, :display_name, :project_id

  belongs_to :project
  has_and_belongs_to_many :subjects

  validates_uniqueness_of :name, case_sensitive: false, scope: :owner
  validates_uniqueness_of :display_name, scope: :owner

  can_by_role :update, roles: [ :collaborator ]
  can_by_role :show, public: true, roles: :visible_to
end
