class AddIsOpenAndSignInLimitAndExcuseLimitToTrainingLessons < ActiveRecord::Migration
  def change
    # default times - hours before start
    add_column :training_lessons, :sign_in_before_start_time_limit, :time, null: false, default: 0
    add_column :training_lessons, :excuse_before_start_time_limit, :time, null: false, default: 0

    # limit dates
    add_column :training_lesson_realizations, :sign_in_time, :datetime
    add_column :training_lesson_realizations, :excuse_time, :datetime
    # limit player count
    add_column :training_lesson_realizations, :player_count_limit, :integer

    # for individual trainings possibility to open training to all players and let them sign
    add_column :training_lesson_realizations, :is_open, :boolean

  end
end
