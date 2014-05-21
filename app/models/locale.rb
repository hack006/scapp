class Locale < ActiveRecord::Base
  # =================== ASSOCIATIONS =================================
  has_many :users

  # =================== VALIDATIONS ==================================
  validates :name, presence: true
  validates :code, presence: true

  # =================== EXTENSIONS ===================================

  # =================== GETTERS / SETTERS ============================

  # =================== METHODS ======================================
end