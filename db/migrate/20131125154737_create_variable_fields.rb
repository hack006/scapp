class CreateVariableFields < ActiveRecord::Migration
  def change
    create_table :variable_fields do |t|
      t.string :name
      t.string :description
      t.string :unit
      t.boolean :higher_is_better
      t.boolean :is_numeric
      t.references :user
      t.references :variable_field_category

      t.timestamps
    end

    add_index :variable_fields, :user_id
    add_index :variable_fields, :variable_field_category_id
  end
end
