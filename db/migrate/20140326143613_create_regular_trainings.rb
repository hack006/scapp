class CreateRegularTrainings < ActiveRecord::Migration
  def change
    create_table :regular_trainings do |t|
      t.string :name
      t.text :description
      t.boolean :public
      t.references :user

      t.timestamps
    end

    add_index :regular_trainings, :user_id
  end
end
