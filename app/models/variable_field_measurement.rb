class VariableFieldMeasurement < ActiveRecord::Base
  belongs_to :measured_by, class_name: "User"
  belongs_to :measured_for, class_name: "User"
  belongs_to :variable_field
end
