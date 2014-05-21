class VariableFieldUserLevel < ActiveRecord::Base
  # =================== ASSOCIATIONS =================================
  has_many :variable_field_optimal_values

  # =================== VALIDATIONS ==================================

  # =================== EXTENSIONS ===================================

  # =================== GETTERS / SETTERS ============================

  # =================== METHODS ======================================
end
