class VariableFieldOptimalValue < ActiveRecord::Base
  # =================== ASSOCIATIONS =================================
  belongs_to :variable_field
  belongs_to :variable_field_sport
  belongs_to :variable_field_user_level

  # =================== VALIDATIONS ==================================

  # =================== EXTENSIONS ===================================

  # =================== GETTERS / SETTERS ============================

  # =================== METHODS ======================================

end
