class Vat < ActiveRecord::Base
  #TODO has many regular training lessons -> dependent restrict

  validates :name, presence: true, uniqueness: true
  validates :percentage_value, numericality: true, presence: true

  # Add seo ids for training
  extend FriendlyId
  friendly_id :name, use: :slugged
end
