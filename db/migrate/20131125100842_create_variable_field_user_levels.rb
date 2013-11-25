class CreateVariableFieldUserLevels < ActiveRecord::Migration
  def change
    create_table :variable_field_user_levels do |t|
      t.string :name

      t.timestamps
    end
  end
end
