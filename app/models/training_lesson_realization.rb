class TrainingLessonRealization < ActiveRecord::Base
  STATUS = [:scheduled, :done, :canceled]
  PRICE_CALCULATIONS = [:fixed_player_price, :fixed_player_price_or_split_the_costs, :split_the_costs]

  # =================== ASSOCIATIONS =================================
  belongs_to :training_vat, class_name: 'Vat'
  belongs_to :rental_vat, class_name: 'Vat'
  has_many :present_coaches, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :variable_field_measurements, dependent: :nullify

  # =================== VALIDATIONS ==================================
  validates :status, presence: true, inclusion: { in: STATUS }
  validates :calculation, presence: true, inclusion: { in: PRICE_CALCULATIONS }
  validates :player_price_without_tax, presence: true, numericality: true, if: :player_based_calculation?
  validates :group_price_without_tax, presence: true, numericality: true, if: :group_based_calculation?
  validates :rental_price_without_tax, numericality: true

  validates :training_vat_id, presence: true
  validates :rental_vat_id, presence: true, if: :exist_rental_costs

  # =================== EXTENSIONS ===================================
  # Set up Friendly id
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  self.inheritance_column = 'training_type'

  # =================== GETTERS / SETTERS ============================

  def status
    read_attribute(:status).to_sym unless read_attribute(:status).nil?
  end

  def status=(status)
    write_attribute(:status, status.to_s)
  end

  def calculation
    read_attribute(:calculation).to_sym unless read_attribute(:calculation).nil?
  end

  def calculation=(calculation)
    write_attribute(:calculation, calculation.to_s)
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

  def lesson_length(time_unit = :hour)
    seconds = (self.until.to_i - self.from.to_i).to_f
    case time_unit
      when :hour
        seconds / 1.hour
      when :minute
        seconds / 1.minute
      else
        raise StandardError, 'time unit not supported'
    end
  end

  # Get closest training realizations for specified user
  #
  #   * lessons owned by user
  #   * lessons user participates as user
  #   * lessons user is coaching
  #
  # @param [User] user obtain lessons with any relation for this user
  # @param [Integer] limit maximum number of scheduled lessons to obtain
  def self.closest_lesson_realizations(user, limit = 10)
    regular_training_player_ids = RegularTraining.for_player(user).map { |t| t.id }
    regular_training_coach_ids = RegularTraining.for_coach(user).map { |t| t.id }
    regular_training_ids = regular_training_coach_ids + regular_training_player_ids
    training_lessons_ids = TrainingLesson.where(regular_training_id: regular_training_ids).map { |l| l.id }
    individual_training_realizations_user_in_ids = IndividualTrainingLessonRealization.
        joins(:attendances).
        where('attendances.user_id = ?', user.id).map{ |r| r.id }.uniq

    TrainingLessonRealization.
        where('(training_type = "IndividualTrainingLessonRealization" AND (user_id = :user_id OR id IN(:realizations_ids))) OR (training_type = "RegularTrainingLessonRealization" AND training_lesson_id IN(:lessons_ids))',
              user_id: user.id, lessons_ids: training_lessons_ids, realizations_ids: individual_training_realizations_user_in_ids).
        where('date >= ?', Date.current).
        order(date: :asc).
        limit(limit)
  end

  # Get closest training realizations trained by specified user
  #
  # @param [User] user user acting as coach
  # @param [Integer] limit maximum number of scheduled lessons to obtain
  def self.closest_trained_by_user(user, limit = 10)
    TrainingLessonRealization.joins(:present_coaches).
        where('present_coaches.user_id = :user_id AND date >= :date', user_id: user.id, date: Date.current).
        order(date: :asc).
        limit(limit).uniq
  end

  # Get closest open training realizations
  #
  # @param [Integer] limit maximum number of lessons to obtain
  def self.closest_open_lesson_realizations(limit = 10)

    TrainingLessonRealization.
        where(training_type: "IndividualTrainingLessonRealization", is_open: true).
        where('date >= ?', Date.current).
        order(date: :asc).
        limit(limit)
  end

  # Get attendances which are involved in the calculation process
  #
  #   Attendances which have status equal to :present or :unexcused
  def calculated_attendances
    self.attendances.includes(:user).where(participation: [:present, :unexcused])
  end

  # Based on price calculation method calculate price for 1 player
  #
  #   Player price is calculated from existing attendance entries with (present, unexcused)statuses.
  #   For result price calculation we use _training_vat_.
  #
  #    *WARNINGS* are thrown if income is lower than rental costs + coaches payment
  #
  #   * For *fixed_player_price* - player price is directly taken from _player price field_
  #   * For *split_the_costs* - following calculation is used
  #     player_price = (group_price_without_tax + training_vat) / player_count
  #   * For *fixed_player_price_or_split_the_costs* - calculate both prices and use the higher one
  #
  # @return [Hash] result price and warnings if costs are higher then income
  #   @option :player_price_without_vat price which :present or :unexcused player has to pay
  #   @option :balance income - costs, plus number is good, minus means lost
  #   @option :is_gainful TRUE if income higher then costs, FALSE otherwise
  #   @option :warning_message Warning message with calculated financial loss
  def calculate_player_price_without_vat
    out = {player_price_without_vat: 0, balance: 0, total_costs: 0, is_gainful: true, warning_message: ''}
    calculation_players_count = self.calculated_attendances.count

    # calculate player price
    case self.calculation
      when :fixed_player_price
      total_income = self.player_price_without_tax * calculation_players_count
      out[:player_price_without_vat] = self.player_price_without_tax

      when :split_the_costs
        total_income = self.group_price_without_tax
        out[:player_price_without_vat] = self.group_price_without_tax / calculation_players_count

      when :fixed_player_price_or_split_the_costs
        fixed_price = self.player_price_without_tax
        split_price = self.group_price_without_tax / calculation_players_count
        total_income = [fixed_price * calculation_players_count, self.group_price_without_tax].max

        out[:player_price_without_vat] = [fixed_price, split_price].max
    end

    # Show warning when costs are mixed from different currencies
    if self.costs.count > 1
      out[:warning_message] = I18n.t('training_realization.model.can_not_check_calculation_different_currencies')
      out[:is_gainful] = false
      out[:total_costs] = 0
      out[:balance] = 0
    else
      # Show warning when training is in loss
      total_costs = self.costs[self.currency.code.to_sym]

      if total_costs > total_income
        out[:is_gainful] = false
        out[:warning_message] = I18n.t('training_realization.model.lesson_not_gainful',
                                       amount: (total_costs - total_income).round(2), currency: self.currency.symbol)
      end
      out[:total_costs] = total_costs
      out[:balance] = total_income - total_costs
    end

    out
  end

  # Calculate costs of scheduled training realization
  #
  #   If _training_vat_ is empty then we are not tax payers, so tax is automatically added to costs.
  #   On the other hand when _training_vat_ exists, we drop tax because we can deduct the VAT
  #
  #   Costs are:
  #
  #   * rental price
  #   * coach wages
  #
  # @return [Hash<Float>] Total costs sorted by currency code (:czk, :usd ..)
  def costs
    # make check if income is higher than costs
    total_costs = { }
    total_costs[self.currency.code.to_sym] = 0 # rental currency is known

    # calculate coach costs
    self.present_coaches.each do |c|
      # TODO in the feature handle possible different currencies EXCHANGE!
      currency_code = c.currency.code.to_sym

      total_costs[currency_code] = 0 if total_costs[currency_code].nil?

      # If training VAT is not zero then we are taxpayers, so calculate coach costs without VAT
      if self.training_vat.nil? || self.training_vat.percentage_value == 0
        total_costs[currency_code] += (c.salary_without_tax * (1 + c.vat.percentage_value / 100))
      else
        total_costs[currency_code] += c.salary_without_tax
      end
    end

    # calculate rental costs, if we are taxpayers (training VAT != 0) we drop rental VAT
    if self.training_vat.nil? || self.training_vat.percentage_value == 0
      total_costs[self.currency.code.to_sym] += self.rental_price_without_tax * (1 + self.rental_vat.percentage_value / 100)
    else
      total_costs[self.currency.code.to_sym] += self.rental_price_without_tax
    end

    total_costs
  end

  # Calculate total income from scheduled training realization
  #
  #   Total income is calculated directly from _attendance_ entries. So, for obtaining right results secure that
  #   calculation process has been run.
  #
  # @return [Float] total income
  def income
    self.attendances.sum(:price_without_tax).to_f
  end

  # =================== HELPER METHODS ============================
  def player_based_calculation?
    calculation == :fixed_player_price || calculation == :fixed_player_price_or_split_the_costs
  end

  def group_based_calculation?
    calculation == :split_the_costs || calculation == :fixed_player_price_or_split_the_costs
  end

  def exist_rental_costs
    !rental_price_without_tax.blank? && rental_price_without_tax != 0
  end

  # Check all formalities of training if it can be closed
  #
  #   FOLLOWING MUST BE MET:
  #
  #   * All attendance participation states are in SET = [:invited, :present, :excused, :unexcused]
  #   * Training is not already *canceled* or *done*
  #
  # @return [Boolean] TRUE if everything is OK, FALSE if there exist some problem
  def can_close?
    return false if self.attendances.where(participation: [:signed]).any?
    return false if self.status == :canceled || self.status == :done

    return true
  end

  # Is scheduled lesson closed
  #
  # @return TRUE if closed, FALSE otherwise
  def closed?
    return true if self.status == :done || self.status == :canceled
    false
  end

  def not_closed?
    !self.closed?
  end

  def is_regular?
    training_type == 'RegularTrainingLessonRealization'
  end

  def is_individual?
    training_type == 'IndividualTrainingLessonRealization'
  end

  # Find out if training realization is owned by specified player
  #
  # @param [User] user
  def is_owned_by?(user)
    (self.is_regular? && self.training_lesson.regular_training.user == user) || (self.is_individual? && self.user == user)
  end

  # Find out if training realization has specified user as coach
  #
  # @param [User] user
  # @param [Hash] options
  #   @option [Boolean] :supplementation
  #   @option [String] :role Can be coach or head_coach, if not specified then both are possible. Only available for regular trainings.
  # @return TRUE if training realization has user as a coach, FALSE otherwise
  def has_coach?(user, options = {})
    if self.is_regular?
      opt_roles = options[:role]
      opt_roles ||= ['coach', 'head_coach']
      head_coaches_ids = self.training_lesson.regular_training.coach_obligations.where(role: opt_roles).map { |c| c.user_id }


      return true if head_coaches_ids.include?(user.id)

      # we have to end here if we are interested only in coaches with specified role
      return false if options.has_key?(:role)
    end

    coach = self.present_coaches.where(user: user)
    coach = coach.where(supplementation: options[:supplementation]) if options.has_key?(:supplementation)
    !coach.empty?
  end

  # Find out if training realization has specified user as player
  #
  # @param [User] user
  # @return TRUE if training realization has user as a player, FALSE otherwise
  def has_player?(user)
    !self.attendances.where(user: user).empty?
  end

  # Find out if training realization has specified user owner
  #
  #   Different approach is made in depence of training lesson type
  #     * individual -> user specified
  #     * regular -> obtain owner from regualar training
  #
  # @param [User] user
  # @return TRUE if training realization has user as a owner, FALSE otherwise
  def has_owner?(user)
    if self.is_individual?
      self.user == user
    else
      self.training_lesson.regular_training.user == user
    end
  end

  # Find out if training realization has specified user as player
  #
  # @param [User] user
  # @return TRUE if training realization has user as a player, FALSE otherwise
  def has_watcher?(user)
    player_ids = self.attendances.map{ |a| a.user.id }
    coach_ids = self.present_coaches.map { |c| c.user.id }
    watched_user_ids = user.get_my_relations_with_statuses('accepted', :my_wards, 'accepted').map{ |u| u.to.id }

    !((player_ids + coach_ids + Array(user.id)) & watched_user_ids).to_a.empty?
  end

end
