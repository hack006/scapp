class AddTrainingRealizationModelTypeColumn < ActiveRecord::Migration
  def change
    add_column :training_lesson_realizations, :training_type, "ENUM('RegularTrainingLessonRealization', 'IndividualTrainingLessonRealization')"

    add_index :training_lesson_realizations, :training_type
  end
end
