class AddFriendlyIdToRegularTrainings < ActiveRecord::Migration
  def change
    add_column :regular_trainings, :slug, :string

    add_index :regular_trainings, :slug, unique: true
  end
end
