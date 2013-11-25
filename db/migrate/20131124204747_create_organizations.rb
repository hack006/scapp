class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :location
      t.string :description
      t.references :user

      t.timestamps
    end

    add_index :organizations, :user_id
  end
end
