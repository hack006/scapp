class CreateUserRelations < ActiveRecord::Migration
  def change
    create_table :user_relations do |t|
      t.string :relation
      t.string :from_user_status
      t.string :to_user_status
      t.references :user_from_id
      t.references :user_to_id

      t.timestamps
    end

    add_index :user_relations, :user_from_id_id
    add_index :user_relations, :user_to_id_id
  end
end
