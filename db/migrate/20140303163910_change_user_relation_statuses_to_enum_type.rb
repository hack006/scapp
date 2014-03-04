class ChangeUserRelationStatusesToEnumType < ActiveRecord::Migration
  def change
    change_column :user_relations, :from_user_status, "ENUM('new', 'refused', 'accepted')", null: false, default: 'new'
    change_column :user_relations, :to_user_status, "ENUM('new', 'refused', 'accepted')", null: false, default: 'new'
    change_column :user_relations, :relation, "ENUM('friend', 'coach', 'watcher')", null: false, default: nil
  end
end
