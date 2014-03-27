class RegularTraining < ActiveRecord::Base
  belongs_to :user
  belongs_to :user_group

  # Add seo ids for training
  extend FriendlyId
  friendly_id :name, use: :slugged

  # TODO associations

  validates :name, presence: true
  validates :name, uniqueness: true
end
