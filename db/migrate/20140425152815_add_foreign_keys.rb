class AddForeignKeys < ActiveRecord::Migration
  def change
    # ATTENDANCES
    add_foreign_key "attendances", "payments", :dependent => :nullify
    add_foreign_key "attendances", "training_lesson_realizations", :dependent => :delete
    add_foreign_key "attendances", "users", :dependent => :restrict, :name => "attendances_for_user_id_fk"
    # COACH OBLIGATIONS
    add_foreign_key "coach_obligations", "currencies", :dependent => :restrict
    add_foreign_key "coach_obligations", "regular_trainings", :dependent => :delete
    add_foreign_key "coach_obligations", "users", :dependent => :restrict
    add_foreign_key "coach_obligations", "vats", :dependent => :restrict
    # PAYMENTS
    add_foreign_key "payments", "currencies", :dependent => :restrict
    # PRESENT COACHES
    add_foreign_key "present_coaches", "currencies", :dependent => :restrict, :name => "present_coaches_salary_currency_id_fk"
    add_foreign_key "present_coaches", "training_lesson_realizations", :dependent => :delete
    add_foreign_key "present_coaches", "users", :dependent => :restrict
    add_foreign_key "present_coaches", "vats", :dependent => :restrict
    # REGULAR TRAININGS
    add_foreign_key "regular_trainings", "user_groups", :dependent => :nullify, :name => "regular_trainings_fo_user_group_id_fk"
    add_foreign_key "regular_trainings", "users", :dependent => :restrict, :name => "regular_trainings_owner_user_id_fk"
    # TRAINING LESSON
    add_foreign_key "training_lessons", "currencies", :dependent => :restrict
    add_foreign_key "training_lessons", "regular_trainings", :dependent => :delete
    add_foreign_key "training_lessons", "vats", :dependent => :restrict, :name => "training_lessons_rental_vat_id_fk", :column => "rental_vat_id"
    add_foreign_key "training_lessons", "vats", :dependent => :restrict, :name => "training_lessons_training_vat_id_fk", :column => "training_vat_id"
    # TRAINING LESSON REALIZATION
    add_foreign_key "training_lesson_realizations", "currencies", :dependent => :restrict
    add_foreign_key "training_lesson_realizations", "vats", :dependent => :restrict, :name => "training_lesson_realizations_rental_vat_id_fk", :column => "rental_vat_id"
    add_foreign_key "training_lesson_realizations", "training_lessons", :dependent => :restrict, :name => "training_lesson_realizations_training_lesson_id_fk"
    add_foreign_key "training_lesson_realizations", "vats", :dependent => :restrict, :name => "training_lesson_realizations_training_vat_id_fk", :column => "training_vat_id"
    add_foreign_key "training_lesson_realizations", "users", :dependent => :restrict, :name => "training_lesson_realizations_owner_user_id_fk"
    # USER GROUP
    add_foreign_key "user_groups", "users", :dependent => :restrict, :name => "user_groups_owner_user_id_fk"
    # USER <-> GROUPS
    add_foreign_key "user_groups_users", "user_groups", :dependent => :delete
    add_foreign_key "user_groups_users", "users", :dependent => :delete
    # USER RELATIONS
    add_foreign_key "user_relations", "users", :dependent => :delete, :name => "user_relations_user_from_id_fk", :column => "user_from_id"
    add_foreign_key "user_relations", "users", :dependent => :delete, :name => "user_relations_user_to_id_fk", :column => "user_to_id"
    # USERS
    add_foreign_key "users", "locales", :dependent => :restrict
    # USER ROLES
    add_foreign_key "users_roles", "roles", :dependent => :restrict
    add_foreign_key "users_roles", "users", :dependent => :delete
    # VARIABLE FIELDS
    add_foreign_key "variable_fields", "users", :dependent => :restrict, :name => "variable_fields_owner_user_id_fk"
    add_foreign_key "variable_fields", "variable_field_categories", :dependent => :nullify, :name => "variable_fields_belongs_to_variable_field_category_id_fk"
    # VARIABLE FIELD CATEGORIES
    add_foreign_key "variable_field_categories", "users", :dependent => :restrict, :name => "variable_field_categories_owner_user_id_fk"
    # VARIABLE FIELD MEASUREMENTS
    add_foreign_key "variable_field_measurements", "users", :dependent => :restrict, :name => "variable_field_measurements_measured_by_id_fk", :column => "measured_by_id"
    add_foreign_key "variable_field_measurements", "users", :dependent => :delete, :name => "variable_field_measurements_measured_for_id_fk", :column => "measured_for_id"
    add_foreign_key "variable_field_measurements", "training_lesson_realizations", :dependent => :nullify, :name => "vfm_measured_on_training_lesson_realization_id_fk"
    add_foreign_key "variable_field_measurements", "variable_fields", :dependent => :restrict
    # VARIABLE FIELD OPTIMAL VALUES
    add_foreign_key "variable_field_optimal_values", "variable_fields", :dependent => :delete
    add_foreign_key "variable_field_optimal_values", "variable_field_sports", :dependent => :delete
    add_foreign_key "variable_field_optimal_values", "variable_field_user_levels", :dependent => :delete

  end
end
