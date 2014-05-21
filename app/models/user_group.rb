# Organize users into groups
#
# @attr [String] visibility
#   @option 'public' Visible to all visitors of webpage
#   @option 'registered' Visible only to users with valid registration
#   @option 'members' Visible to members of group = _members_, _owner_, _:watchers_ of _:players_, _coaches_ of _:players_
#   @option 'owner' Visible only to owner. Useful for internal organization

class UserGroup < ActiveRecord::Base
  GROUP_VISIBILITIES = [:public, :registered, :members, :owner]

  # =================== ASSOCIATIONS =================================
  has_and_belongs_to_many :users
  belongs_to :owner, class_name: User, foreign_key: 'user_id'
  has_many :regular_trainings, dependent: :restrict_with_exception # can not be deleted if

  # =================== VALIDATIONS ==================================
  validates :name, presence: true
  validates :visibility, inclusion: {in: GROUP_VISIBILITIES}

  # =================== EXTENSIONS ===================================
  scope :owned_by, -> (user) { where('user_groups.user_id = ?', user.id) }
  scope :global, -> { where('user_groups.is_global = 1') }
  scope :with_visibility, -> (visibilities) { where('visibility IN (?)', visibilities.to_a) }
  scope :global_or_owned_by, -> (user) { where('user_groups.user_id = ? OR user_groups.is_global = 1', user.id) }

  # =================== GETTERS / SETTERS ============================
  def visibility()
    read_attribute(:visibility).to_sym unless read_attribute(:visibility).nil?
  end

  def visibility=(visibility)
    write_attribute(:visibility, visibility.to_s)
  end

  # =================== METHODS ======================================
  # Test if user belongs to group
  #
  # @param [User] user
  # @return TRUE if user is in group, FALSE otherwise
  def user_is_in?(user)
    self.users.include? user
  end

  def self.groups_user_is_in(user)
    if user.is_admin?
      # can see all
      user.user_groups
    else
      # can see all without owner visible groups which is not in user ownership
      user.user_groups.where('visibility != "owner" OR user_groups.user_id = ?', user.id)
    end
  end

  # Get groups I own, I am in or groups that are :public or :registered visible
  #
  # @param [User] user for whom we find groups
  # @return [ActiveRecord::Relation] groups visible to registered used
  def self.registered_visible(user)
    # TODO fix when UNION implemented
    # HACK - no better solution possible yet :-/
    ids = UserGroup.find_by_sql("#{UserGroup.owned_by(user).to_sql} UNION
                                 #{UserGroup.groups_user_is_in(user).to_sql} UNION
                                 #{UserGroup.with_visibility(['public', 'registered']).to_sql}").map{|ug| ug.id}

    UserGroup.where(id: ids)
  end
end
