# Organize users into groups
#
# @attr [String] visibility
#   @option 'public' Visible to all visitors of webpage
#   @option 'registered' Visible only to users with valid registration
#   @option 'members' Visible to members of group = _members_, _owner_, _:watchers_ of _:players_, _coaches_ of _:players_
#   @option 'owner' Visible only to owner. Useful for internal organization

class UserGroup < ActiveRecord::Base
  has_and_belongs_to_many :users

  validates :visibility, inclusion: {in: ['public', 'registered', 'members', 'owner']}
end
