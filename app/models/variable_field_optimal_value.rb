class VariableFieldOptimalValue < ActiveRecord::Base
  belongs_to :variable_field
  belongs_to :variable_field_sport
  belongs_to :variable_field_user_level

end
