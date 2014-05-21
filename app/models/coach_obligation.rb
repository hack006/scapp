class CoachObligation < ActiveRecord::Base
  ROLES = [:coach, :head_coach]

  # =================== ASSOCIATIONS =================================
  belongs_to :vat
  belongs_to :currency
  belongs_to :user
  belongs_to :regular_training

  # =================== EXTENSIONS ===================================
  attr_accessor :coach_email

  # =================== VALIDATIONS ==================================
  validates :hourly_wage_without_vat, presence: true, numericality: true
  validates :vat_id, presence: true
  validates :currency_id, presence: true
  validates :coach_email, presence: true
  validates :role, presence: true
  validate :coach_email_exist_in_system

  # =================== GETTERS / SETTERS ============================

  # =================== METHODS ======================================
  def coach_email_exist_in_system
    unless User.where(email: self.coach_email).count > 0
      self.errors[:coach_email] << I18n.t('coach_obligation.create.email_not_found')
    end
  end
end
