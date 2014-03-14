class ChangeUserGroupVisibilityToEnumType < ActiveRecord::Migration
  def change
    change_column :user_groups, :visibility, "ENUM('public', 'registered', 'members', 'owner')", null: false, default: 'owner'
  end
end
