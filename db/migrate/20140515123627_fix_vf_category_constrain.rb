class FixVfCategoryConstrain < ActiveRecord::Migration
  def change
    # VFC should not be possible to remove if connected VF exists
    remove_foreign_key :variable_fields, :name => "variable_fields_belongs_to_variable_field_category_id_fk"
    add_foreign_key "variable_fields", "variable_field_categories", :dependent => :restrict, :name => "variable_fields_belongs_to_variable_field_category_id_fk"
  end
end
