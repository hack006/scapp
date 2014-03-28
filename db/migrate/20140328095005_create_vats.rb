class CreateVats < ActiveRecord::Migration
  def change
    create_table :vats do |t|
      t.string :name
      t.string :slug
      t.float :percentage_value
      t.boolean :is_time_limited
      t.datetime :start_of_validity
      t.datetime :end_of_validity

      t.timestamps
    end

    add_index :vats, :slug, unique: true
  end
end
