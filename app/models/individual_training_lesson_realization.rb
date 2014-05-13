class IndividualTrainingLessonRealization < TrainingLessonRealization
  # =================== ASSOCIATIONS =================================
  belongs_to :currency
  belongs_to :user

  # =================== VALIDATIONS ==================================
  validates :date, presence: true
  validates :from, presence: true
  validates :until, presence: true
  validates :currency_id, presence: true
  validates :user_id, presence: true

  # =================== EXTENSIONS ===================================
  # Suggest slugs to use
  def slug_candidates
    if self.date && self.from && self.until && self.user
      date_str = self.date.short
      from_time_str = self.from.short
      until_time_str = self.until.short
      user_slug = self.user.slug

      # slug guess
      [[user_slug, date_str, from_time_str, until_time_str]]
    else
      ['somefake']
    end
  end
  # =================== GETTERS / SETTERS ============================

  # =================== METHODS ======================================
  # Get information if we can sign in to training
  #   * signed players < limit
  #   * deadline not reached
  # @return [Boolean, String] true if sign in is possible, false otherwise + error messages
  def can_sign_in?
    errors = []

    unless self.is_open?
      errors << I18n.t('training_realization.model.sign_in_not_possible_not_open_lesson')
    end

    signed_players_count = self.attendances.where(participation: :signed).count
    if self.player_count_limit <= signed_players_count
      errors << I18n.t('training_realization.model.signed_in_player_limit_reached')
    end

    if (DateTime.current > self.sign_in_time)
      errors << I18n.t('training_realization.model.sign_in_time_limit_reached')
    end

    return errors.empty?, errors.join(' ')
  end

end