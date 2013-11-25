class CreateVariableFieldSports < ActiveRecord::Migration
  def change
    create_table :variable_field_sports do |t|
      t.string :name

      t.timestamps
    end
  end
end
