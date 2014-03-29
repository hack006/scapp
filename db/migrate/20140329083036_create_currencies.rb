class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :name
      t.string :code
      t.string :symbol

      t.timestamps
    end

    add_column :training_lessons, :currency_id, :integer, null: false
    add_index :training_lessons, :currency_id
  end
end
