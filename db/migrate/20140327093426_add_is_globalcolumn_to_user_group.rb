class AddIsGlobalcolumnToUserGroup < ActiveRecord::Migration
  def change
    add_column :user_groups, :is_global, :boolean, default: 0
  end
end
