class AddLocaleColumnToUser < ActiveRecord::Migration
  create_table(:locales) do |t|
    t.string :name, null: false
    t.string :code, null: false
  end

  def change
    add_column :users, :locale_id, :integer, null: false
    add_index :users, :locale_id
  end
end
