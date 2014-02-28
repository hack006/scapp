class AddIsGlobalToVfAndVfc < ActiveRecord::Migration
  def change
    add_column :variable_fields, :is_global, :boolean
    add_column :variable_field_categories, :is_global, :boolean
  end
end
