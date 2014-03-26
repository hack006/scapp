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

ActiveRecord::Schema.define(version: 20140320224325) do

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.string   "location"
    t.string   "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "organizations", ["user_id"], name: "index_organizations_on_user_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "user_groups", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "visibility",       limit: 10, default: "owner", null: false
    t.integer  "user_id"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "long_description"
  end

  add_index "user_groups", ["organization_id"], name: "index_user_groups_on_organization_id", using: :btree
  add_index "user_groups", ["user_id"], name: "index_user_groups_on_user_id", using: :btree

  create_table "user_groups_users", force: true do |t|
    t.integer "user_id",       null: false
    t.integer "user_group_id", null: false
  end

  add_index "user_groups_users", ["user_group_id"], name: "index_user_groups_users_on_user_group_id", using: :btree
  add_index "user_groups_users", ["user_id", "user_group_id"], name: "index_user_groups_users_on_user_id_and_user_group_id", unique: true, using: :btree
  add_index "user_groups_users", ["user_id"], name: "index_user_groups_users_on_user_id", using: :btree

  create_table "user_relations", force: true do |t|
    t.string   "relation",         limit: 7,                 null: false
    t.string   "from_user_status", limit: 8, default: "new", null: false
    t.string   "to_user_status",   limit: 8, default: "new", null: false
    t.integer  "user_from_id"
    t.integer  "user_to_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_relations", ["user_from_id"], name: "index_user_relations_on_user_from_id", using: :btree
  add_index "user_relations", ["user_to_id"], name: "index_user_relations_on_user_to_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "slug"
    t.string   "avatar"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "variable_field_categories", force: true do |t|
    t.string   "name"
    t.string   "rgb"
    t.string   "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_global"
  end

  add_index "variable_field_categories", ["user_id"], name: "index_variable_field_categories_on_user_id", using: :btree

  create_table "variable_field_measurements", force: true do |t|
    t.datetime "measured_at"
    t.string   "locality"
    t.string   "string_value"
    t.float    "int_value"
    t.integer  "measured_by_id"
    t.integer  "measured_for_id"
    t.integer  "variable_field_id"
  end

  add_index "variable_field_measurements", ["measured_by_id"], name: "index_variable_field_measurements_on_measured_by_id", using: :btree
  add_index "variable_field_measurements", ["measured_for_id"], name: "index_variable_field_measurements_on_measured_for_id", using: :btree
  add_index "variable_field_measurements", ["variable_field_id"], name: "index_variable_field_measurements_on_variable_field_id", using: :btree

  create_table "variable_field_optimal_values", force: true do |t|
    t.float    "bottom_limit"
    t.float    "upper_limit"
    t.string   "source"
    t.integer  "variable_field_id"
    t.integer  "variable_field_sport_id"
    t.integer  "variable_field_user_level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "variable_field_optimal_values", ["variable_field_id"], name: "index_variable_field_optimal_values_on_variable_field_id", using: :btree
  add_index "variable_field_optimal_values", ["variable_field_sport_id"], name: "index_variable_field_optimal_values_on_variable_field_sport_id", using: :btree
  add_index "variable_field_optimal_values", ["variable_field_user_level_id"], name: "variable_field_opt_val_on_level_id", using: :btree

  create_table "variable_field_sports", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "variable_field_user_levels", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "variable_fields", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "unit"
    t.boolean  "higher_is_better"
    t.boolean  "is_numeric"
    t.integer  "user_id"
    t.integer  "variable_field_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_global"
  end

  add_index "variable_fields", ["user_id", "name"], name: "index_variable_fields_on_user_id_and_name", unique: true, using: :btree
  add_index "variable_fields", ["user_id"], name: "index_variable_fields_on_user_id", using: :btree
  add_index "variable_fields", ["variable_field_category_id"], name: "index_variable_fields_on_variable_field_category_id", using: :btree

end
