class CreateUserGroupsUsersHabtmTable < ActiveRecord::Migration
  def change
    create_table :user_groups_users do |t|
      t.integer :user_id, null: false
      t.integer :group_id, null: false
    end
  end
end
