class VfcSetGlobalDefaultToFalse < ActiveRecord::Migration
  def change
    change_column :variable_field_categories, :is_global, :boolean, default: false
  end
end
