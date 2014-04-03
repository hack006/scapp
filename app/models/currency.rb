class Currency < ActiveRecord::Base
  has_many :coach_obligations, dependent: :restrict_with_exception
  has_many :training_lessons, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: true
  validates :code, presence: true
  validates :symbol, presence: true

  # Add seo ids for training
  extend FriendlyId
  friendly_id :name, use: :slugged
end
