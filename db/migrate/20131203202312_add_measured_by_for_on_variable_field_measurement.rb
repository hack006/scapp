class AddMeasuredByForOnVariableFieldMeasurement < ActiveRecord::Migration
  def change
    add_column :variable_field_measurements, :measured_by_id, :integer
    add_column :variable_field_measurements, :measured_for_id, :integer
    add_column :variable_field_measurements, :variable_field_id, :integer

    add_index :variable_field_measurements, :measured_by_id
    add_index :variable_field_measurements, :measured_for_id
    add_index :variable_field_measurements, :variable_field_id
  end
end
