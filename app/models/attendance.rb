class Attendance < ActiveRecord::Base
  PARTICIPATION_STATES = [:invited,:signed,:present,:excused,:unexcused]
  # =================== ASSOCIATIONS =================================
  belongs_to :training_lesson_realization
  belongs_to :user
  belongs_to :payment

  # =================== VALIDATIONS ==================================
  validates :participation, presence: true, inclusion: { in: PARTICIPATION_STATES }
  validates :training_lesson_realization_id, presence: true
  validates :user_id, presence: true
  validates :user_email, presence: true, on: :create
  validates :price_without_tax, presence: true, numericality: true
  validates_uniqueness_of :training_lesson_realization_id, scope: :user_id

  # =================== EXTENSIONS ===================================
  attr_accessor :user_email

  # =================== GETTERS / SETTERS ============================
  def participation
    read_attribute(:participation).to_sym unless read_attribute(:participation).nil?
  end

  def participation=(participation_status)
    unless PARTICIPATION_STATES.include? participation_status.to_sym
      raise ArgumentError, 'Not in list.'
    end

    write_attribute(:participation, participation_status.to_s)
  end

  # =================== METHODS ======================================
  def price_with_tax
    price_without_tax * (1 + self.training_lesson_realization.training_vat.percentage_value / 100)
  end

  # Check if attendance can be excused by player
  #
  #   * training realization is not closed (done, canceled)
  #   * we are in excuse limit
  #   * if no excuse time limit is set then lesson start time is used
  #
  # @return [Boolean] TRUE if user can excuse, FALSE otherwise
  def can_excuse?
    errors = []
    if [:done, :canceled].include?(self.training_lesson_realization.status)
      errors << I18n.t('attendance.model.can_not_excuse_training_already_closed')
    end

    if ((self.training_lesson_realization.excuse_time.to_i - Time.current.to_i) < 0)
      errors << I18n.t('attendance.model.can_not_excuse_training_excuse_time_reached')
    end

    return errors.empty?, errors.join(' ')
  end

  # Check if attendance can be signed in by player
  #
  #   * training realization is not closed (done, canceled)
  #   * we are in sign in limit
  #   * if no sign in time limit is set then lesson start time is used
  #
  # @return [Boolean] TRUE if user can sign in, FALSE otherwise
  def can_sign_in?
    if [:done, :canceled].include?(self.training_lesson_realization.status) ||
        ( !self.training_lesson_realization.sign_in_time.nil? && ((self.training_lesson_realization.sign_in_time.to_i - Time.current.to_i) < 0)) ||
        ( (DateTime.from_date_and_time(self.training_lesson_realization.date, self.training_lesson_realization.from).to_i - Time.current.to_i) < 0)
      return false
    else
      return true
    end
  end


end
