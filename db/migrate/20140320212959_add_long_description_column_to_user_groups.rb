class AddLongDescriptionColumnToUserGroups < ActiveRecord::Migration
  def change
    add_column :user_groups, :long_description, :text
  end
end
