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

    # regular trainings I am in as player
    @regular_trainings_as_player = @user.regular_trainings_training_in

    # regular trainings I coach
    @regular_trainings_as_coach = @user.regular_trainings_coaching

    # TODO closest trainings - TrainingLessonRealization

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