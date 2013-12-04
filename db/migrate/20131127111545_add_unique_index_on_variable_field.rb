class AddUniqueIndexOnVariableField < ActiveRecord::Migration
  def change
    add_index :variable_fields, [:user_id, :name], :unique => true
  end
end
