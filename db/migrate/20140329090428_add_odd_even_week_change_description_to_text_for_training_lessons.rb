class AddOddEvenWeekChangeDescriptionToTextForTrainingLessons < ActiveRecord::Migration
  def change
    add_column :training_lessons, :even_week, :boolean, null: false, default: 1
    add_column :training_lessons, :odd_week, :boolean, null: false, default: 1
    change_column :training_lessons, :description, :text
  end
end
