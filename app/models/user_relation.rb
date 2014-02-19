class UserRelation < ActiveRecord::Base
  belongs_to :from, class: User, foreign_key: 'user_from_id'
  belongs_to :to, class: User, foreign_key: 'user_to_id'
end
