class RegularTraining < ActiveRecord::Base
  # =================== ASSOCIATIONS =================================
  belongs_to :user
  belongs_to :user_group
  has_many :training_lessons
  has_many :coach_obligations

  # =================== VALIDATIONS ==================================
  validates :name, presence: true
  validates :name, uniqueness: true

  # =================== EXTENSIONS ===================================
  # Add seo ids for training
  extend FriendlyId
  friendly_id :name, use: :slugged

  scope :public, -> { where(public: true) }

  # =================== GETTERS / SETTERS ============================

  # =================== METHODS ======================================
  # Get training lessons count per week
  #
  # @param [Hash]
  #   @option :odd number of lessons in the odd week
  #   @option :even number of lessons in the even week
  def lessons_per_week
    lessons_per_odd_week = self.training_lessons.where(odd_week: true).count
    lessons_per_even_week = self.training_lessons.where(even_week: true).count

    { odd: lessons_per_odd_week, even: lessons_per_even_week }
  end

  def get_possible_lessons_between_dates(start_date, end_date)
    # todo ADD from-date, until-date limit
    day_abbreviation_map = { 1 => :mon, 2 => :tue, 3 => :wed, 4 => :thu, 5 => :fri, 6 => :sat, 0 => :sun }
    trainings = []

    start_date.step(end_date, 1).each do |day|
      day_of_week_abbrev = day_abbreviation_map[day.wday]
      week_in_year = day.strftime('%W').to_i
      odd_week = (week_in_year % 2) == 1

      # try to get regular training lessons for current day & even / odd week
      conditions = { day: day_of_week_abbrev }
      conditions[:odd_week] =  true if odd_week
      conditions[:even_week] = true unless odd_week
      self.training_lessons.where(conditions).each do |l|
        # add lesson for current day
        training_id = "#{l.id}\##{day.short}"
        # check if not already added
        unless RegularTrainingLessonRealization.where(training_lesson_id: training_id, date: day).empty?
          state = :scheduled
        else
          state = :unscheduled
        end

        # guess only training lessons which are in specified date range
        # TODO - later better to implement this into sql query ;)
        if ( l.from_date.blank? || (day - l.from_date.to_date) > 0) && (l.until_date.blank? || (day - l.until_date.to_date) < 0)
          trainings << { id: training_id, date: day, from: l.from, until: l.until, day: day_of_week_abbrev, state: state}
        end
      end

      # todo keep in mind that even and odd week makes difference!

    end

    trainings
  end

  # Get closest training lessons realizations by date
  #
  # @param [Integer] count number of trainings
  def closest_lessons(count = 5)
    regular_lessons_ids = self.training_lessons.map{ |l| l.id }

    RegularTrainingLessonRealization.where('training_lesson_id IN(:rtl_ids) AND date >= :date',
                                           rtl_ids: regular_lessons_ids, date: Date.current).limit(count)
  end

  # Get regular trainings for specified player
  #
  # @param [User] user
  # @return found regular trainings
  def self.for_player(user)
    RegularTraining.where(user_group_id: user.user_groups)
  end

  # Get regular trainings trained by specified coach
  #
  # @param [User] user
  # @return found regular trainings
  def self.for_coach(user)
    RegularTraining.joins(:coach_obligations).where('coach_obligations.user_id = ?', user.id)
  end

  # Test if user is player in current regular training
  #
  # @param [User] user
  # @return TRUE if user is player of current training, FALSE otherwise
  def has_player?(user)
    self.user_group.users.include?(user)
  end

  # Test if user is coach of current regular training
  #
  # @param [User] user
  # @param [Symbol] coach_roles
  #   @option :coach
  #   @option :head_coach
  # @return TRUE if user is coach of current training, FALSE otherwise
  def has_coach?(user, coach_roles = CoachObligation::ROLES)
    !self.coach_obligations.where(user: user, role: coach_roles).empty?
  end

  # Test if user is watcher of any player / coach / owner
  #
  # @param [User] user
  # @return TRUE if user has valid watcher relation to any player / coach / owner, FALSE otherwise
  def has_watcher?(user)
    player_ids = self.user_group.users.map { |u| u.id }
    coach_ids = self.coach_obligations.map { |u| u.user.id }
    watched_user_ids = user.get_my_relations_with_statuses('accepted', :my_wards, 'accepted').map{ |u| u.to.id }

    !((player_ids + coach_ids + Array(user.id)) & watched_user_ids).to_a.empty?
  end

end
