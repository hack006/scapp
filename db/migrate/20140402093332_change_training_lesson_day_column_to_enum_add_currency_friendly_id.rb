class ChangeTrainingLessonDayColumnToEnumAddCurrencyFriendlyId < ActiveRecord::Migration
  def change
    change_column :training_lessons, :day, "ENUM('mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun')", null: false
    add_column :currencies, :slug, :string, null: false

    add_index :currencies, :slug, unique: true
  end
end
