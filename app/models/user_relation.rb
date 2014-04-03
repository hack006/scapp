# Holds relation between Users
#
# @attr [String] from_user_status
#   @option [String] :new
#   @option [String] :accepted
#   @option [String] :refused
# @attr [String] to_user_status
#   @option [String] :new
#   @option [String] :accepted
#   @option [String] :refused
# @attr [String] relation
#   @option [String] :friend
#   @option [String] :coach _user_from_ is coach of _user_to_
#   @option [String] :watcher _user_from_ is watcher of _user_to

class UserRelation < ActiveRecord::Base
  RELATION_TYPES = ['friend', 'coach', 'watcher']
  RELATION_STATUSES = ['new', 'accepted', 'refused']

  belongs_to :from, class_name: User, foreign_key: 'user_from_id'
  belongs_to :to, class_name: User, foreign_key: 'user_to_id'

  # accessors for "artificial" fields in form
  attr_accessor :first_user, :second_user

  #validates :relation, inclusion: { in: ['friend', 'coach', 'watcher'] }
  validates :from_user_status, inclusion: { in: ['new', 'accepted', 'refused'] }
  validates :to_user_status, inclusion: { in: ['new', 'accepted', 'refused'] }
  validates :relation, presence: true

  # Relation getter
  #
  # @return [Symbol] relation type
  def relation
    unless self[:relation].nil?
      return self[:relation].to_sym
    else
      return nil
    end
  end

  # Relation setter
  #
  # @param [Symbol, String] relation relation type
  def relation=(relation)
    unless relation.kind_of? Symbol
      self[:relation] = relation.to_sym
    else
      self[:relation] = symbol
    end
  end

  # Test if specified relation exists between users
  #
  # @param [String] relation_type
  #   @option [String] :friend
  #   @option [String] :coach _from_user_ is coach of _to_user_
  #   @option [String] :watcher _from_user_ is watcher of _to_user_
  # @param [User] from_user
  # @param [User] to_user
  def self.in_relation?(from_user, to_user, relation_type)
    if relation_type == :friend
      # check connection in both directions
      c1 = UserRelation.where(user_from_id: from_user, user_to_id: to_user, relation: relation_type,
                              to_user_status: 'accepted', from_user_status: 'accepted').count
      c2 = UserRelation.where(user_from_id: to_user, user_to_id: from_user, relation: relation_type,
                              to_user_status: 'accepted', from_user_status: 'accepted').count
      c1 > 0 || c2 > 0
    else
      UserRelation.where(user_from_id: from_user, user_to_id: to_user, relation: relation_type,
                         to_user_status: 'accepted', from_user_status: 'accepted').count > 0
    end
  end

  # Create relation between 2 users
  #
  # @param [User] from_user
  # @param [User] to_user
  # @param [String] relation_type
  #   @option [String] 'friend'
  #   @option [String] 'coach' _from_user_ is coach of _to_user_
  #   @option [String] 'watcher' _from_user_ is watcher of _to_user_
  # @param [String] from_user_status
  #   @option [String] 'new'
  #   @option [String] 'accepted'
  #   @option [String] 'refused'
  # @param [String] to_user_status
  #   @option [String] 'new'
  #   @option [String] 'accepted'
  #   @option [String] 'refused'
  def self.add_relation(from_user, to_user, relation_type, from_user_status = 'accepted', to_user_status = 'new')
    UserRelation.create!(from: from_user, to: to_user, relation: relation_type, from_user_status: from_user_status,
                     to_user_status: to_user_status)
  end

  # Get user relations with specified statuses and relation type
  #
  # @param [User] user
  # @param [Array<String>, String] user_relation_statuses Specify statuses of relations on user side to obtain
  # @param [Symbol] relation
  #   @option [Symbol] :all All user relations
  #   @option [Symbol] :friends Users who are friends with _user_
  #   @option [Symbol] :my_coaches Users who do _user_ coach
  #   @option [Symbol] :my_players Users who has _user_ as coach
  #   @option [Symbol] :my_watchers Users who watch _user_
  #   @option [Symbol] :my_wards Users who _user_ is watching
  # @return relations
  def self.get_my_relations_with_statuses(user, user_relation_statuses = ['accepted'], relation = :all, my_side_relation_status = ['new', 'accepted', 'refused'])
    rel = nil
    case relation
      when :all
        rel = UserRelation.where("(user_from_id = :user AND from_user_status IN (:status) AND to_user_status IN (:my_status)) OR (user_to_id = :user AND to_user_status IN (:status) AND from_user_status IN (:my_status))",
                                 { user: user, status: user_relation_statuses, my_status: my_side_relation_status })
      when :friends
       rel =  UserRelation.where("((user_from_id = :user AND from_user_status IN (:status) AND to_user_status IN (:my_status)) OR (user_to_id = :user AND to_user_status IN (:status) AND from_user_status IN (:my_status)))" +
                           " AND relation = 'friend'",
                           { user: user, status: user_relation_statuses, my_status: my_side_relation_status })
      when :my_coaches
        rel = UserRelation.where("user_to_id = :user AND to_user_status IN (:status) AND from_user_status IN (:my_status) AND relation = 'coach'",
                                 { user: user, status: user_relation_statuses, my_status: my_side_relation_status })
      when :my_players
        rel = UserRelation.where("user_from_id = :user AND from_user_status IN (:status) AND to_user_status IN (:my_status) AND relation = 'coach'",
                                 { user: user, status: user_relation_statuses, my_status: my_side_relation_status })
      when :my_watchers
        rel = UserRelation.where("user_to_id = :user AND to_user_status IN (:status) AND from_user_status IN (:my_status) AND relation = 'watcher'",
                                 { user: user, status: user_relation_statuses, my_status: my_side_relation_status })
      when :my_wards
        rel = UserRelation.where("user_from_id = :user AND from_user_status IN (:status) AND to_user_status IN (:my_status) AND relation = 'watcher'",
                                 { user: user, status: user_relation_statuses, my_status: my_side_relation_status })
    end

    rel
  end
end
