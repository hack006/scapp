class CreateTrainingLessons < ActiveRecord::Migration
  def change
    create_table :training_lessons do |t|
      t.string :description
      t.string :day
      t.time :from
      t.time :until
      t.column :calculation, "ENUM('fixed_player_price', 'fixed_player_price_or_split_the_costs', 'split_the_costs')"
      t.datetime :from_date
      t.datetime :until_date
      t.float :player_price_without_tax
      t.float :group_price_without_tax
      t.float :rental_price_without_tax
      t.integer :training_vat_id
      t.integer :rental_vat_id
      t.integer :regular_training_id

      t.timestamps
    end

    add_index :training_lessons, :training_vat_id
    add_index :training_lessons, :rental_vat_id
    add_index :training_lessons, :regular_training_id

  end
end
