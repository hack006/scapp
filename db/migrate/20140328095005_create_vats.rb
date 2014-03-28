class CreateVats < ActiveRecord::Migration
  def change
    create_table :vats do |t|
      t.string :name
      t.float :percentage_value
      t.boolean :is_time_limited
      t.datetime :start_of_validity
      t.datetime :end_of_validity

      t.timestamps
    end
  end
end
