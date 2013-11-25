class CreateVariableFieldOptimalValues < ActiveRecord::Migration
  def change
    create_table :variable_field_optimal_values do |t|
      t.float :bottom_limit
      t.float :upper_limit
      t.string :source
      t.references :variable_field
      t.references :variable_field_sport
      t.references :variable_field_user_level

      t.timestamps
    end

    add_index :variable_field_optimal_values, :variable_field_id
    add_index :variable_field_optimal_values, :variable_field_sport_id
    add_index :variable_field_optimal_values, :variable_field_user_level_id, name: 'variable_field_opt_val_on_level_id'
  end
end
