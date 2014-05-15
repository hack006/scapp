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

ActiveRecord::Schema.define(version: 20140515123627) do

  create_table "attendances", force: true do |t|
    t.string   "participation",                  limit: 9
    t.float    "price_without_tax"
    t.datetime "player_change"
    t.integer  "training_lesson_realization_id"
    t.integer  "user_id"
    t.integer  "payment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "note"
    t.string   "excuse_reason"
  end

  add_index "attendances", ["payment_id"], name: "index_attendances_on_payment_id", using: :btree
  add_index "attendances", ["training_lesson_realization_id"], name: "index_attendances_on_training_lesson_realization_id", using: :btree
  add_index "attendances", ["user_id"], name: "index_attendances_on_user_id", using: :btree

  create_table "coach_obligations", force: true do |t|
    t.float    "hourly_wage_without_vat"
    t.string   "role",                    limit: 10, default: "coach", null: false
    t.integer  "vat_id",                                               null: false
    t.integer  "currency_id",                                          null: false
    t.integer  "user_id",                                              null: false
    t.integer  "regular_training_id",                                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coach_obligations", ["currency_id"], name: "index_coach_obligations_on_currency_id", using: :btree
  add_index "coach_obligations", ["regular_training_id"], name: "index_coach_obligations_on_regular_training_id", using: :btree
  add_index "coach_obligations", ["user_id", "regular_training_id"], name: "index_coach_obligations_on_user_id_and_regular_training_id", unique: true, using: :btree
  add_index "coach_obligations", ["user_id"], name: "index_coach_obligations_on_user_id", using: :btree
  add_index "coach_obligations", ["vat_id"], name: "index_coach_obligations_on_vat_id", using: :btree

  create_table "currencies", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "symbol"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug",       null: false
  end

  add_index "currencies", ["slug"], name: "index_currencies_on_slug", unique: true, using: :btree

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

  create_table "locales", force: true do |t|
    t.string "name", null: false
    t.string "code", null: false
  end

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.string   "location"
    t.string   "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "organizations", ["user_id"], name: "index_organizations_on_user_id", using: :btree

  create_table "payments", force: true do |t|
    t.float    "amount"
    t.string   "status",         limit: 15, default: "waiting_payment", null: false
    t.integer  "currency_id",                                           null: false
    t.integer  "received_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payments", ["currency_id"], name: "index_payments_on_currency_id", using: :btree
  add_index "payments", ["received_by_id"], name: "index_payments_on_received_by_id", using: :btree

  create_table "present_coaches", force: true do |t|
    t.float    "salary_without_tax"
    t.integer  "vat_id"
    t.integer  "currency_id"
    t.integer  "user_id"
    t.integer  "training_lesson_realization_id"
    t.boolean  "supplementation",                default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "present_coaches", ["currency_id"], name: "index_present_coaches_on_currency_id", using: :btree
  add_index "present_coaches", ["training_lesson_realization_id"], name: "index_present_coaches_on_training_lesson_realization_id", using: :btree
  add_index "present_coaches", ["user_id"], name: "index_present_coaches_on_user_id", using: :btree
  add_index "present_coaches", ["vat_id"], name: "index_present_coaches_on_vat_id", using: :btree

  create_table "regular_trainings", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "public"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_group_id"
    t.string   "slug"
  end

  add_index "regular_trainings", ["slug"], name: "index_regular_trainings_on_slug", unique: true, using: :btree
  add_index "regular_trainings", ["user_group_id"], name: "regular_trainings_fo_user_group_id_fk", using: :btree
  add_index "regular_trainings", ["user_id"], name: "index_regular_trainings_on_user_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "training_lesson_realizations", force: true do |t|
    t.string   "slug"
    t.date     "date"
    t.time     "from"
    t.time     "until"
    t.float    "player_price_without_tax"
    t.float    "group_price_without_tax"
    t.float    "rental_price_without_tax"
    t.string   "calculation"
    t.string   "status"
    t.text     "note"
    t.integer  "training_vat_id"
    t.integer  "rental_vat_id"
    t.integer  "currency_id"
    t.integer  "training_lesson_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "training_type",            limit: 35
    t.datetime "sign_in_time"
    t.datetime "excuse_time"
    t.integer  "player_count_limit"
    t.boolean  "is_open"
  end

  add_index "training_lesson_realizations", ["currency_id"], name: "index_training_lesson_realizations_on_currency_id", using: :btree
  add_index "training_lesson_realizations", ["rental_vat_id"], name: "index_training_lesson_realizations_on_rental_vat_id", using: :btree
  add_index "training_lesson_realizations", ["slug"], name: "index_training_lesson_realizations_on_slug", unique: true, using: :btree
  add_index "training_lesson_realizations", ["training_lesson_id"], name: "index_training_lesson_realizations_on_training_lesson_id", using: :btree
  add_index "training_lesson_realizations", ["training_type"], name: "index_training_lesson_realizations_on_training_type", using: :btree
  add_index "training_lesson_realizations", ["training_vat_id"], name: "index_training_lesson_realizations_on_training_vat_id", using: :btree
  add_index "training_lesson_realizations", ["user_id"], name: "index_training_lesson_realizations_on_user_id", using: :btree

  create_table "training_lessons", force: true do |t|
    t.text     "description"
    t.string   "day",                             limit: 3,                                  null: false
    t.time     "from"
    t.time     "until"
    t.string   "calculation",                     limit: 37
    t.datetime "from_date"
    t.datetime "until_date"
    t.float    "player_price_without_tax"
    t.float    "group_price_without_tax"
    t.float    "rental_price_without_tax"
    t.integer  "training_vat_id"
    t.integer  "rental_vat_id"
    t.integer  "regular_training_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "currency_id",                                                                null: false
    t.boolean  "even_week",                                  default: true,                  null: false
    t.boolean  "odd_week",                                   default: true,                  null: false
    t.time     "sign_in_before_start_time_limit",            default: '2000-01-01 00:00:00', null: false
    t.time     "excuse_before_start_time_limit",             default: '2000-01-01 00:00:00', null: false
  end

  add_index "training_lessons", ["currency_id"], name: "index_training_lessons_on_currency_id", using: :btree
  add_index "training_lessons", ["regular_training_id"], name: "index_training_lessons_on_regular_training_id", using: :btree
  add_index "training_lessons", ["rental_vat_id"], name: "index_training_lessons_on_rental_vat_id", using: :btree
  add_index "training_lessons", ["training_vat_id"], name: "index_training_lessons_on_training_vat_id", using: :btree

  create_table "user_groups", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "visibility",       limit: 10, default: "owner", null: false
    t.integer  "user_id"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "long_description"
    t.boolean  "is_global",                   default: false
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
    t.string   "email",                             default: "", null: false
    t.string   "encrypted_password",                default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "slug"
    t.string   "avatar"
    t.integer  "locale_id",                                      null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "sex",                    limit: 6
    t.string   "handedness",             limit: 12
    t.date     "birthday"
    t.string   "phone"
    t.text     "about_me"
    t.string   "city"
    t.string   "street"
    t.string   "post_code"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["locale_id"], name: "index_users_on_locale_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["role_id"], name: "users_roles_role_id_fk", using: :btree
  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "variable_field_categories", force: true do |t|
    t.string   "name"
    t.string   "rgb"
    t.string   "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_global",   default: false
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
    t.integer  "training_lesson_realization_id"
  end

  add_index "variable_field_measurements", ["measured_by_id"], name: "index_variable_field_measurements_on_measured_by_id", using: :btree
  add_index "variable_field_measurements", ["measured_for_id"], name: "index_variable_field_measurements_on_measured_for_id", using: :btree
  add_index "variable_field_measurements", ["training_lesson_realization_id"], name: "tlr_id", using: :btree
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

  create_table "vats", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.float    "percentage_value"
    t.boolean  "is_time_limited"
    t.datetime "start_of_validity"
    t.datetime "end_of_validity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vats", ["slug"], name: "index_vats_on_slug", unique: true, using: :btree

  add_foreign_key "attendances", "payments", :name => "attendances_payment_id_fk", :dependent => :nullify
  add_foreign_key "attendances", "training_lesson_realizations", :name => "attendances_training_lesson_realization_id_fk", :dependent => :delete
  add_foreign_key "attendances", "users", :name => "attendances_for_user_id_fk"

  add_foreign_key "coach_obligations", "currencies", :name => "coach_obligations_currency_id_fk"
  add_foreign_key "coach_obligations", "regular_trainings", :name => "coach_obligations_regular_training_id_fk", :dependent => :delete
  add_foreign_key "coach_obligations", "users", :name => "coach_obligations_user_id_fk"
  add_foreign_key "coach_obligations", "vats", :name => "coach_obligations_vat_id_fk"

  add_foreign_key "payments", "currencies", :name => "payments_currency_id_fk"

  add_foreign_key "present_coaches", "currencies", :name => "present_coaches_salary_currency_id_fk"
  add_foreign_key "present_coaches", "training_lesson_realizations", :name => "present_coaches_training_lesson_realization_id_fk", :dependent => :delete
  add_foreign_key "present_coaches", "users", :name => "present_coaches_user_id_fk"
  add_foreign_key "present_coaches", "vats", :name => "present_coaches_vat_id_fk"

  add_foreign_key "regular_trainings", "user_groups", :name => "regular_trainings_fo_user_group_id_fk", :dependent => :nullify
  add_foreign_key "regular_trainings", "users", :name => "regular_trainings_owner_user_id_fk"

  add_foreign_key "training_lesson_realizations", "currencies", :name => "training_lesson_realizations_currency_id_fk"
  add_foreign_key "training_lesson_realizations", "training_lessons", :name => "training_lesson_realizations_training_lesson_id_fk"
  add_foreign_key "training_lesson_realizations", "users", :name => "training_lesson_realizations_owner_user_id_fk"
  add_foreign_key "training_lesson_realizations", "vats", :name => "training_lesson_realizations_rental_vat_id_fk", :column => "rental_vat_id"
  add_foreign_key "training_lesson_realizations", "vats", :name => "training_lesson_realizations_training_vat_id_fk", :column => "training_vat_id"

  add_foreign_key "training_lessons", "currencies", :name => "training_lessons_currency_id_fk"
  add_foreign_key "training_lessons", "regular_trainings", :name => "training_lessons_regular_training_id_fk", :dependent => :delete
  add_foreign_key "training_lessons", "vats", :name => "training_lessons_rental_vat_id_fk", :column => "rental_vat_id"
  add_foreign_key "training_lessons", "vats", :name => "training_lessons_training_vat_id_fk", :column => "training_vat_id"

  add_foreign_key "user_groups", "users", :name => "user_groups_owner_user_id_fk"

  add_foreign_key "user_groups_users", "user_groups", :name => "user_groups_users_user_group_id_fk", :dependent => :delete
  add_foreign_key "user_groups_users", "users", :name => "user_groups_users_user_id_fk", :dependent => :delete

  add_foreign_key "user_relations", "users", :name => "user_relations_user_from_id_fk", :column => "user_from_id", :dependent => :delete
  add_foreign_key "user_relations", "users", :name => "user_relations_user_to_id_fk", :column => "user_to_id", :dependent => :delete

  add_foreign_key "users", "locales", :name => "users_locale_id_fk"

  add_foreign_key "users_roles", "roles", :name => "users_roles_role_id_fk"
  add_foreign_key "users_roles", "users", :name => "users_roles_user_id_fk", :dependent => :delete

  add_foreign_key "variable_field_categories", "users", :name => "variable_field_categories_owner_user_id_fk"

  add_foreign_key "variable_field_measurements", "training_lesson_realizations", :name => "vfm_measured_on_training_lesson_realization_id_fk", :dependent => :nullify
  add_foreign_key "variable_field_measurements", "users", :name => "variable_field_measurements_measured_by_id_fk", :column => "measured_by_id"
  add_foreign_key "variable_field_measurements", "users", :name => "variable_field_measurements_measured_for_id_fk", :column => "measured_for_id", :dependent => :delete
  add_foreign_key "variable_field_measurements", "variable_fields", :name => "variable_field_measurements_variable_field_id_fk"

  add_foreign_key "variable_field_optimal_values", "variable_field_sports", :name => "variable_field_optimal_values_variable_field_sport_id_fk", :dependent => :delete
  add_foreign_key "variable_field_optimal_values", "variable_field_user_levels", :name => "variable_field_optimal_values_variable_field_user_level_id_fk", :dependent => :delete
  add_foreign_key "variable_field_optimal_values", "variable_fields", :name => "variable_field_optimal_values_variable_field_id_fk", :dependent => :delete

  add_foreign_key "variable_fields", "users", :name => "variable_fields_owner_user_id_fk"
  add_foreign_key "variable_fields", "variable_field_categories", :name => "variable_fields_belongs_to_variable_field_category_id_fk"

end
