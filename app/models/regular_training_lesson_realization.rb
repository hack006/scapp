class RegularTrainingLessonRealization < TrainingLessonRealization
  # =================== ASSOCIATIONS =================================
  belongs_to :training_lesson


  # =================== VALIDATIONS ==================================
  validates :training_lesson_id, presence: true
  validates_uniqueness_of :date, scope: :training_lesson

  # =================== EXTENSIONS ===================================
  # Currency, from, until, day is used from training lesson
  #   - DISABLE setter
  #   - getters are delegated
  delegate :currency, :currency_id, :until, :from, :day, to: :training_lesson

  # Suggest slugs to use
  def slug_candidates
    date_str = self.date.short
    from_time_str = self.from.short
    until_time_str = self.until.short
    regular_training_slug = self.training_lesson.regular_training.slug

    # slug guess
    [[regular_training_slug, date_str, from_time_str, until_time_str]]
  end

  # =================== GETTERS / SETTERS ============================
  def currency_id=(id)
    raise 'Can not assign!'
  end

  def until=(until_time)
    raise 'Can not assign!'
  end

  def from=(from_time)
    raise 'Can not assign!'
  end

  def day=(day)
    raise 'Can not assign!'
  end

  # =================== METHODS ======================================

  # Add present coach for current training lesson
  #
  # User must exist in regular training coach obligations because
  # we use entered params such as coach salary, VAT, currency
  #
  # @param [User] user Coach we want to add
  # @raise [CoachObligationNotExistError]
  # @raise [UserNotExistError]
  # @raise [PresentCoachAlreadyExistError]
  # @raise [PresentCoachAlreadyExistError]
  # @return [Coach]
  def add_present_coach_from_training_obligations(user)
    # try to find coach obligation for selected user and current regular training
    if (coach_obligation = self.training_lesson.regular_training.coach_obligations.where(user: user).first).nil?
      raise CoachObligationNotExistError
    end

    # test present coach if already not exist
    unless self.present_coaches.where(user: user).empty?
      raise PresentCoachAlreadyExistError
    end

    # everything seems ok, add present coach
    PresentCoach.create(salary_without_tax: (coach_obligation.hourly_wage_without_vat * self.training_lesson.training_length(:hour)),
                        vat: coach_obligation.vat, currency: coach_obligation.currency,
                        user: user, user_email: user.email, training_lesson_realization: self, supplementation: false)

  end

  # Add players assigned in regular training group to attandance evidence
  #
  # @raise [StandardError] when some part failed, concanated string of fails is returned
  # @return
  def add_players_evidence_from_training_group
    errors = []
    self.training_lesson.regular_training.user_group.users.each do |u|
      if self.attendances.where(user: u).empty?
        begin
          # try to add players
          Attendance.create!(participation: :signed, price_without_tax: 0, training_lesson_realization: self, user: u, user_email: u.email)
        rescue Exception => e
          errors << e.message
        end
      end
    end

    raise StandardError, errors.join("\n") unless errors.empty?
  end

end