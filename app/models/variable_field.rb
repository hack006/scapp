class VariableField < ActiveRecord::Base
  belongs_to :user
  belongs_to :variable_field_category
  has_many :variable_field_measurements, dependent: :restrict_with_exception
  has_many :variable_field_optimal_values, dependent: :destroy

  attr_accessor :modification_confirmation

  validates :name, length: 1..64
  validates_uniqueness_of :name, scope: [:variable_field_category_id, :user_id]
  validates :variable_field_category, presence: true

  scope :public_or_owned_by, ->(user_id) { where("user_id is NULL or user_id = ?", user_id) }

  def has_to_confirm_edit?
    (variable_field_measurements.count > 0) ? true : false
  end

  def confirmation_token
    Digest::MD5.hexdigest(attributes.to_s).gsub(/[^[0-9]]/, "")[0..5]
  end

end
