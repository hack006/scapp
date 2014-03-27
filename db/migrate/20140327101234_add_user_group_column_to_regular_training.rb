class AddUserGroupColumnToRegularTraining < ActiveRecord::Migration
  def change
    add_column :regular_trainings, :user_group_id, :integer, null: true
  end
end
