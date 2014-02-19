class VariableFieldMeasurement < ActiveRecord::Base
  belongs_to :measured_by, class_name: User, foreign_key: 'measured_by_id'
  belongs_to :measured_for, class_name: User, foreign_key: 'measured_for_id'
  belongs_to :variable_field
end
