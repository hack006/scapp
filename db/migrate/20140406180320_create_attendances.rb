class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.column :participation, "ENUM('invited', 'signed', 'present', 'excused', 'unexcused')"
      t.float :price_without_tax
      t.datetime :player_change
      t.references :training_lesson_realization, index: true
      t.references :user, index: true
      t.references :payment, index: true

      t.timestamps
    end
  end
end
