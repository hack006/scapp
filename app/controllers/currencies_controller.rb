class CurrenciesController < ApplicationController
  before_action :set_currency, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource except: [:create]

  # GET /currencies
  # GET /currencies.json
  def index
    @currencies = Currency.all.page(params[:page])
  end

  # GET /currencies/1
  # GET /currencies/1.json
  def show
  end

  # GET /currencies/new
  def new
    @currency = Currency.new
  end

  # GET /currencies/1/edit
  def edit
  end

  # POST /currencies
  # POST /currencies.json
  def create
    @currency = Currency.new(currency_params)

    authorize! :create, @currency

    respond_to do |format|
      if @currency.save
        format.html { redirect_to currencies_path, notice: 'Currency was successfully created.' }
        format.json { render action: 'show', status: :created, location: @currency }
      else
        format.html { render action: 'new' }
        format.json { render json: @currency.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /currencies/1
  # PATCH/PUT /currencies/1.json
  def update
    respond_to do |format|
      if @currency.update(currency_params)
        format.html { redirect_to @currency, notice: 'Currency was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @currency.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /currencies/1
  # DELETE /currencies/1.json
  def destroy
    respond_to do |format|
      begin
        @currency.destroy
        format.html { redirect_to currencies_url, notice: t('currency.controller.successfully_removed') }
        format.json { head :no_content }
      rescue ActiveRecord::DeleteRestrictionError => e
        format.html { redirect_to currencies_url, alert: t('currency.controller.dependent_exists') }
        format.json { render json: { error: 'Can not delete. Currency is already in use!' }.to_json, status: :unprocessable_entity }
      end

    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_currency
      @currency = Currency.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def currency_params
      params.require(:currency).permit(:name, :code, :symbol)
    end
end
