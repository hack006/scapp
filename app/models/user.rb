class User < ActiveRecord::Base
  USER_ROLES = ['watcher', 'player', 'coach', 'admin']

  # Add seo ids for user
  extend FriendlyId
  friendly_id :name, use: :slugged

  # Mount uploader for avatar
  mount_uploader :avatar, AvatarUploader

  # Add roles
  rolify

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :variable_fields
  has_many :variable_field_categories
  has_many :user_relations
  has_and_belongs_to_many :user_groups
  belongs_to :locale

  validates :locale_id, presence: true

  # Test if specified relation exists between users
  #
  # @param [User] to_user
  # @param [String] relation_type
  #   @option [String] :friend
  #   @option [String] :coach _user_ is coach of _to_user_
  #   @option [String] :watcher _user_ is watcher of _to_user_
  def in_relation?(to_user, relation_type)
    UserRelation.in_relation? self, to_user, relation_type
  end

  # Get user relations with specified statuses
  #
  # @param [Array<String>, String] user_relation_statuses Specify statuses of relations on user side to obtain
  #   @option [String] 'accepted'
  #   @option [String] 'new' When created and no reaction from user is taken
  #   @option [String] 'refused'
  # @param [Symbol] relation
  #   @option [Symbol] :all All user relations
  #   @option [Symbol] :friends Users who are friends with _user_
  #   @option [Symbol] :my_coaches Users who do _user_ coach
  #   @option [Symbol] :my_players Users who has _user_ as coach
  #   @option [Symbol] :my_watchers Users who watch _user_
  #   @option [Symbol] :my_wards Users who _user_ is watching
  # @param [Array<String>, String] my_relation_statuses Specify statuses of relations on my side
  #   @option [String] 'accepted'
  #   @option [String] 'new' When created and no reaction from user is taken
  #   @option [String] 'refused'
  # @return relations
  def get_my_relations_with_statuses(user_relation_statuses = ['accepted'], relation = :all, my_relation_statuses = ['new', 'accepted', 'refused'])
    UserRelation.get_my_relations_with_statuses self, user_relation_statuses, relation, my_relation_statuses
  end

  # Get regular trainings user is assigned in as player
  def regular_trainings_training_in
    RegularTraining.for_player(self)
  end

  # Get regular trainings user is assigned in as coach
  def regular_trainings_coaching
    RegularTraining.for_coach(self)
  end

  def is_admin?
    self.has_role? :admin
  end

  def is_coach?
    self.has_role? :coach
  end

  def is_player?
    self.has_role? :player
  end

  def is_watcher?
    self.has_role? :watcher
  end
end
