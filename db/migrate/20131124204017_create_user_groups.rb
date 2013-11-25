class CreateUserGroups < ActiveRecord::Migration
  def change
    create_table :user_groups do |t|
      t.string :name
      t.string :description
      t.string :visibility
      t.references :user
      t.references :organization

      t.timestamps
    end

    add_index :user_groups, :user_id
    add_index :user_groups, :organization_id
  end
end
