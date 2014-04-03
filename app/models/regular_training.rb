class RegularTraining < ActiveRecord::Base
  belongs_to :user
  belongs_to :user_group
  has_many :training_lessons
  has_many :coach_obligations

  # Add seo ids for training
  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name, presence: true
  validates :name, uniqueness: true

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
