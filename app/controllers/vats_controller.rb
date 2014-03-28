class VatsController < ApplicationController
  before_action :set_vat, only: [ :edit, :update, :destroy]

  load_and_authorize_resource except: [:create]

  # GET /vats
  # GET /vats.json
  def index
    @vats = Vat.all.order(slug: :asc).page(params[:page])
  end

  # GET /vats/1
  # GET /vats/1.json
  def show
    # only for JSON
  end

  # GET /vats/new
  def new
    @vat = Vat.new
  end

  # GET /vats/1/edit
  def edit
  end

  # POST /vats
  # POST /vats.json
  def create
    authorize! :create, Vat

    @vat = Vat.new(vat_params)

    respond_to do |format|
      if @vat.save
        format.html { redirect_to vats_path, notice: t('vat.controller.successfully_created') }
        format.json { render action: 'show', status: :created, location: @vat }
      else
        format.html { render action: 'new' }
        format.json { render json: @vat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vats/1
  # PATCH/PUT /vats/1.json
  def update
    respond_to do |format|
      if @vat.update(vat_params.except(:name, :percentage_value))
        format.html { redirect_to vats_path, notice: t('vat.controller.successfully_updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @vat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vats/1
  # DELETE /vats/1.json
  def destroy
    @vat.destroy
    respond_to do |format|
      format.html { redirect_to vats_url, notice: t('vat.controller.successfully_removed') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vat
      @vat = Vat.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vat_params
      params.require(:vat).permit(:name, :percentage_value, :is_time_limited, :start_of_validity, :end_of_validity)
    end
end
