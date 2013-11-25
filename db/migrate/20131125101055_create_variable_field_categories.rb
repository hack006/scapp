class CreateVariableFieldCategories < ActiveRecord::Migration
  def change
    create_table :variable_field_categories do |t|
      t.string :name
      t.string :rgb
      t.string :description
      t.references :user

      t.timestamps
    end

    add_index :variable_field_categories, :user_id
  end
end
