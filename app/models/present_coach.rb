class PresentCoach < ActiveRecord::Base
  # =================== ASSOCIATIONS =================================
  belongs_to :vat
  belongs_to :currency
  belongs_to :user
  belongs_to :training_lesson_realization

  # =================== VALIDATIONS ==================================
  validates :salary_without_tax, presence: true, numericality: true
  validates :vat_id, presence: true
  validates :currency_id, presence: true
  validates :user_id, presence: true, on: :create
  validates :training_lesson_realization_id, presence: true
  validates_uniqueness_of :user_id, scope: :training_lesson_realization_id
  validate on: :create do |present_coach|
    user = User.where(email: present_coach.user_email).first

    if user.nil?
      present_coach.errors[:user_email] << I18n.t('present_coach.validation.no_user_found')
    end

    if !user.nil? && !PresentCoach.where(user_id: user.id, training_lesson_realization_id: present_coach.training_lesson_realization.id).empty?
      present_coach.errors[:user_email] << I18n.t('present_coach.validation.user_already_added')
    end
  end

  # =================== EXTENSIONS ===================================
  attr_accessor :user_email

  # =================== GETTERS / SETTERS ============================
end
