class VariableFieldMeasurement < ActiveRecord::Base
  belongs_to :measured_by, class_name: User, foreign_key: 'measured_by_id'
  belongs_to :measured_for, class_name: User, foreign_key: 'measured_for_id'
  belongs_to :variable_field

  scope :latest_for_user, -> (user, count) { where(measured_for_id: user).order('measured_at DESC').limit(count) }

  validates :measured_at, presence: true
  validates :variable_field_id, presence: true
  validates :int_value, presence: true, if: 'variable_field && variable_field.is_numeric?'
  validates :int_value, numericality: true
  validates :string_value, presence: true, if: 'variable_field && !variable_field.is_numeric?'
  validates :measured_for_id, presence: true
end
