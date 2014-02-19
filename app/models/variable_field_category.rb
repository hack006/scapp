class VariableFieldCategory < ActiveRecord::Base
  belongs_to :user
  has_many :variable_fields

  scope :owned_by_user_or_public, ->(user_id) { where("user_id is NULL OR user_id = ?", user_id)}
end
