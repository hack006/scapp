class TrainingsController < ApplicationController
  before_action :set_user

  # Show summary of trainings of given user
  #   - regular trainings (is player, is coach)
  #   - closest training hours
  #   - calendar overview
  #
  # GET /users/{user_id}/trainings
  #
  # @controller_action
  def user_overview
    # TODO permissions + implement

    # closest trainings for user
    @closest_training_lessons = TrainingLessonRealization.closest_lesson_realizations(@user)
    @closest_training_lessons = @closest_training_lessons.includes(:attendances)

    # close trainings of watched players
    @closest_training_lessons_watched = TrainingLessonRealization.closest_watched_lesson_realizations(@user)

    # regular trainings I am in as player
    @regular_trainings_as_player = @user.regular_trainings_training_in

    # regular trainings I coach
    @regular_trainings_as_coach = @user.regular_trainings_coaching if is_admin? || is_coach?

    @closest_open_training_lessons = TrainingLessonRealization.closest_open_lesson_realizations

    respond_to do |format|
      format.html{ render 'users/trainings/overview' }
    end
  end

  private
    # Load user
    def set_user
      @user = User.friendly.find(params[:user_id])
    end

end