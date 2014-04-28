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

end