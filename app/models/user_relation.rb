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

  belongs_to :from, class_name: User, foreign_key: 'user_from_id'
  belongs_to :to, class_name: User, foreign_key: 'user_to_id'

  #validates :relation, inclusion: { in: ['friend', 'coach', 'watcher'] }
  validates :from_user_status, inclusion: { in: ['new', 'accepted', 'refused'] }
  validates :to_user_status, inclusion: { in: ['new', 'accepted', 'refused'] }

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
    UserRelation.where(user_from_id: from_user, user_to_id: to_user, relation: relation_type,
                       to_user_status: 'accepted', from_user_status: 'accepted').count > 0
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

  # Get user relations with specified statuses
  #
  # @param [User] user
  # @param [Array<String>, String] relation_statuses Specify statuses of relations on user side to obtain
  # @return relations
  def self.get_my_relations_with_statuses(user, relation_statuses)
    UserRelation.where("(user_from_id = :user AND from_user_status = :status) OR (user_to_id = :user AND to_user_status = :status)",
                       { user: user, status: relation_statuses })
  end
end
