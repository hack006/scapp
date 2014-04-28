class AddTrainingLessonRealizationIdColumnToVariableFieldMeasurement < ActiveRecord::Migration
  def change
    add_column :variable_field_measurements, :training_lesson_realization_id, :integer

    add_index :variable_field_measurements, :training_lesson_realization_id, name: 'tlr_id'
  end
end
