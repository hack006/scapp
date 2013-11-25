class CreateVariableFieldMeasurements < ActiveRecord::Migration
  def change
    create_table :variable_field_measurements do |t|
      t.timestamp :measured_at
      t.string :locality
      t.string :string_value
      t.float :int_value
    end
  end
end
