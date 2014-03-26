class FixUserGroupsUsersTable < ActiveRecord::Migration
  def change
    rename_column :user_groups_users, :group_id, :user_group_id

    add_index :user_groups_users, :user_group_id
    add_index :user_groups_users, :user_id
    add_index :user_groups_users, [:user_id, :user_group_id], unique: true
  end
end
