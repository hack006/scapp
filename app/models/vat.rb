class Vat < ActiveRecord::Base
  # =================== ASSOCIATIONS =================================
  has_many :training_lessons_vats, class_name: 'TrainingLesson', foreign_key: :training_vat_id, dependent: :restrict_with_exception
  has_many :training_lessons_rental_vats, class_name: 'TrainingLesson', foreign_key: :rental_vat_id, dependent: :restrict_with_exception
  has_many :coach_obligations, dependent: :restrict_with_exception

  # =================== VALIDATIONS ==================================
  validates :name, presence: true, uniqueness: true
  validates :percentage_value, numericality: true, presence: true

  # =================== EXTENSIONS ===================================
  # Add seo ids for training
  extend FriendlyId
  friendly_id :name, use: :slugged

  # =================== GETTERS / SETTERS ============================

  # =================== METHODS ======================================
end