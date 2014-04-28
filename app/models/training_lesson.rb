class TrainingLesson < ActiveRecord::Base
  PRICE_CALCULATIONS = [:fixed_player_price, :fixed_player_price_or_split_the_costs, :split_the_costs]
  DAYS = [:mon, :tue, :wed, :thu, :fri, :sat, :sun]

  # =================== EXTENSIONS ===================================
  # We can not update some attributes (date, currency) because these params are reused in lesson realization
  before_update :prevent_attributes_update

  # =================== ASSOCIATIONS =================================
  belongs_to :training_vat, class_name: 'Vat'
  belongs_to :rental_vat, class_name: 'Vat'
  belongs_to :regular_training
  belongs_to :currency
  has_many :regular_training_lesson_realizations

  # =================== VALIDATIONS ==================================
  validates :day, presence: true, inclusion: { in: DAYS }
  validates :from, presence: true
  validates :until, presence: true
  validates :sign_in_before_start_time_limit, presence: true
  validates :excuse_before_start_time_limit, presence: true
  validates :calculation, presence: true, inclusion: { in: PRICE_CALCULATIONS }
  validates :player_price_without_tax, presence: true, numericality: true, if: :player_based_calculation?
  validates :group_price_without_tax, presence: true, numericality: true, if: :group_based_calculation?
  validates :rental_price_without_tax, numericality: true

  validates :currency_id, presence: true
  validates :training_vat_id, presence: true
  validates :rental_vat_id, presence: true, if: :exist_rental_costs

  # =================== GETTERS / SETTERS ============================
  # Calculation getter
  # @return [Symbol] calculation method
  def calculation
    read_attribute(:calculation).to_sym unless read_attribute(:calculation).blank?
  end

  # Set calculation method
  #
  # @param [Symbol] calculation calculation method
  #   @option :fixed_player_price each player pays (player_price_without_tax * training_vat)
  #   @option :fixed_player_price_or_split_the_costs
  #   @option :split_the_costs
  def calculation=(calculation)
    write_attribute(:calculation, calculation.to_s) unless calculation.blank?
  end

  # Day getter
  # @return [Symbol] day abbreviation
  def day
    read_attribute(:day).to_sym unless read_attribute(:day).blank?
  end

  # Set day
  #
  # @param [Symbol] day
  #   @option :mon
  #   @option :tue
  #   @option :wed
  #   @option :thu
  #   @option :fri
  #   @option :sat
  #   @option :sun
  def day=(day)
    write_attribute(:day, day.to_s) unless day.blank?
  end

  # =================== METHODS ======================================
  # Get player hourly fee include VAT
  #
  # @return [Float] fee include VAT
  def player_price_with_tax
    if training_vat
      player_price_without_tax * (1 + (training_vat.percentage_value / 100))
    else
      player_price_without_tax
    end
  end

  # Get group hourly fee include VAT
  #
  # @return [Float] fee include VAT
  def group_price_with_tax
    if training_vat
      group_price_without_tax * (1 + (training_vat.percentage_value / 100))
    else
      group_price_without_tax
    end
  end

  # Get hourly fee include VAT paid for renting sport field etc
  #
  # @return [Float] hourly fee include VAT
  def rental_price_with_tax
    if rental_vat
      rental_price_without_tax * (1 + (rental_vat.percentage_value / 100))
    else
      rental_price_without_tax
    end
  end

  # Get training lesson length in minutes
  #
  # @param [Symbol] time_unit
  #   @option :min
  #   @option :hour
  # @return [Integer] length of lesson in minutes
  def training_length(time_unit = :min, round_precision = 0)
    raise Exception, 'Provided time unit not supported!' unless [:min, :hour].include?(time_unit)

    case time_unit
      when :min
        ((self.until - self.from) / 1.minute).round(round_precision)
      when :hour
      ((self.until - self.from) / 1.hour).round(round_precision)
    end

  end

  # Schedule training lesson for specified date
  #   Reuse most of values from training lesson and copy it.
  #   If needed further modification possible after creation.
  #
  # @param [Date] date date to schedule lesson on
  # @param [Symbol] status
  #   @option :scheduled
  #   @option :canceled
  #   @option :done
  def add_to_schedule(date, status = :scheduled)
    # TODO check if date is valid
    l = self
    RegularTrainingLessonRealization.create(training_lesson: l, date: date,
                                            player_price_without_tax: l.player_price_without_tax,
                                            group_price_without_tax: l.group_price_without_tax,
                                            rental_price_without_tax: l.rental_price_without_tax,
                                            calculation: l.calculation, status: status, training_vat: l.training_vat,
                                            rental_vat: l.rental_vat)
  end

  # Get closest training lessons realizations by date
  #
  # @param [Integer] count number of trainings
  def closest_lessons(count = 5)
    self.regular_training_lesson_realizations.where('date >= :date', date: Date.current).order(date: :asc).limit(count)
  end

  private

    def player_based_calculation?
      calculation == :fixed_player_price || calculation == :fixed_player_price_or_split_the_costs
    end

    def group_based_calculation?
      calculation == :split_the_costs || calculation == :fixed_player_price_or_split_the_costs
    end

    def exist_rental_costs
      !rental_price_without_tax.blank? && rental_price_without_tax != 0
    end

    def prevent_attributes_update
        @changed_attributes.except!('day', 'from', 'until', 'currency_id') unless regular_training_lesson_realizations.empty?
    end

end
