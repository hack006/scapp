class VariableField < ActiveRecord::Base
  belongs_to :user
  belongs_to :variable_field_category
end
