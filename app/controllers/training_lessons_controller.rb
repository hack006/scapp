class TrainingLessonsController < ApplicationController
  before_action :set_training_lesson, only: [:show, :edit, :update, :destroy]

  # GET /training_lessons
  # GET /training_lessons.json
  def index
    @training_lessons = TrainingLesson.all
  end

  # GET /training_lessons/1
  # GET /training_lessons/1.json
  def show
  end

  # GET /training_lessons/new
  def new
    @training_lesson = TrainingLesson.new
  end

  # GET /training_lessons/1/edit
  def edit
  end

  # POST /training_lessons
  # POST /training_lessons.json
  def create
    @training_lesson = TrainingLesson.new(training_lesson_params)

    respond_to do |format|
      if @training_lesson.save
        format.html { redirect_to @training_lesson, notice: 'Training lesson was successfully created.' }
        format.json { render action: 'show', status: :created, location: @training_lesson }
      else
        format.html { render action: 'new' }
        format.json { render json: @training_lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /training_lessons/1
  # PATCH/PUT /training_lessons/1.json
  def update
    respond_to do |format|
      if @training_lesson.update(training_lesson_params)
        format.html { redirect_to @training_lesson, notice: 'Training lesson was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @training_lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /training_lessons/1
  # DELETE /training_lessons/1.json
  def destroy
    @training_lesson.destroy
    respond_to do |format|
      format.html { redirect_to training_lessons_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_training_lesson
      @training_lesson = TrainingLesson.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def training_lesson_params
      params.require(:training_lesson).permit(:description, :day, :from, :until, :calculation, :from_date, :until_date, :player_price_without_tax, :group_price_without_tax, :rental_price_without_tax, :training_vat_id, :rental_vat, :regular_training_id)
    end
end
