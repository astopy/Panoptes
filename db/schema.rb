# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140529202059) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "classifications", force: true do |t|
    t.integer  "set_member_subject_id"
    t.integer  "project_id"
    t.integer  "user_id"
    t.integer  "workflow_id"
    t.json     "annotations"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "classifications", ["project_id"], name: "index_classifications_on_project_id", using: :btree
  add_index "classifications", ["set_member_subject_id"], name: "index_classifications_on_set_member_subject_id", using: :btree
  add_index "classifications", ["user_id"], name: "index_classifications_on_user_id", using: :btree
  add_index "classifications", ["workflow_id"], name: "index_classifications_on_workflow_id", using: :btree

  create_table "collections", force: true do |t|
    t.string   "name"
    t.integer  "project_id"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "owner_type"
  end

  add_index "collections", ["owner_id"], name: "index_collections_on_owner_id", using: :btree
  add_index "collections", ["project_id"], name: "index_collections_on_project_id", using: :btree

  create_table "collections_subjects", id: false, force: true do |t|
    t.integer "subject_id",    null: false
    t.integer "collection_id", null: false
  end

  create_table "memberships", force: true do |t|
    t.integer  "state"
    t.integer  "user_group_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["user_group_id"], name: "index_memberships_on_user_group_id", using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "oauth_access_grants", force: true do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: true do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: true do |t|
    t.string   "name",         null: false
    t.string   "uid",          null: false
    t.string   "secret",       null: false
    t.text     "redirect_uri", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.string   "owner_type"
  end

  add_index "oauth_applications", ["owner_id", "owner_type"], name: "index_oauth_applications_on_owner_id_and_owner_type", using: :btree
  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "projects", force: true do |t|
    t.string   "name"
    t.string   "display_name"
    t.integer  "classification_count"
    t.integer  "user_count"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "owner_type"
  end

  add_index "projects", ["name"], name: "index_projects_on_name", unique: true, using: :btree
  add_index "projects", ["owner_id"], name: "index_projects_on_owner_id", using: :btree

  create_table "set_member_subjects", force: true do |t|
    t.integer  "state"
    t.integer  "subject_set_id"
    t.integer  "classification_count"
    t.integer  "subject_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "set_member_subjects", ["subject_id"], name: "index_set_member_subjects_on_subject_id", using: :btree
  add_index "set_member_subjects", ["subject_set_id"], name: "index_set_member_subjects_on_subject_set_id", using: :btree

  create_table "subject_sets", force: true do |t|
    t.string   "name"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subject_sets", ["project_id"], name: "index_subject_sets_on_project_id", using: :btree

  create_table "subject_sets_workflows", id: false, force: true do |t|
    t.integer "subject_set_id", null: false
    t.integer "workflow_id",    null: false
  end

  create_table "subjects", force: true do |t|
    t.string   "zooniverse_id"
    t.json     "metadata"
    t.json     "locations"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subjects", ["zooniverse_id"], name: "index_subjects_on_zooniverse_id", unique: true, using: :btree

  create_table "uri_names", force: true do |t|
    t.string   "name"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "uri_names", ["name"], name: "index_uri_names_on_name", unique: true, using: :btree

  create_table "user_groups", force: true do |t|
    t.string   "display_name"
    t.integer  "classification_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",       null: false
    t.string   "encrypted_password",     default: "",       null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,        null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login",                                     null: false
    t.string   "hash_func",              default: "bcrypt"
    t.string   "password_salt"
    t.string   "display_name"
    t.string   "zooniverse_id"
    t.string   "credited_name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["login"], name: "index_users_on_login", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "workflows", force: true do |t|
    t.string   "name"
    t.json     "tasks"
    t.integer  "classification_count"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "workflows", ["project_id"], name: "index_workflows_on_project_id", using: :btree

end