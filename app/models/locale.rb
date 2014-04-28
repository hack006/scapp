class Locale < ActiveRecord::Base
  has_many :users

  validates :name, presence: true
  validates :code, presence: true
end
