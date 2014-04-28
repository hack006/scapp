require 'spec_helper'

describe TrainingLessonRealization do

  # INITIALIZATION OF REQUIRED MODELS#################################################################################
  before do
    # init users
    @user1 = FactoryGirl.create(:coach, name: 'test1', email: 'test1@example.com')
    @user2 = FactoryGirl.create(:player, name: 'test2', email: 'test2@example.com')
    @user3 = FactoryGirl.create(:player, name: 'test3', email: 'test3@example.com')
    @user4 = FactoryGirl.create(:player, name: 'test4', email: 'test4@example.com')

    @vat = Vat.create(name: 'Basic VAT', percentage_value: 20, is_time_limited: false)
    @no_vat = Vat.create(name: 'No VAT', percentage_value: 0, is_time_limited: false)

    @currency = Currency.create(name: 'Euro', code: 'EUR', symbol: '€')
    @currency2 = Currency.create(name: 'USD', code: 'USD', symbol: '$')

    # init training lesson realization
    #`id`, `slug`, `date`, `from`, `until`, `player_price_without_tax`, `group_price_without_tax`, `rental_price_without_tax`, `calculation`,
    # `status`, `note`, `training_vat_id`, `rental_vat_id`, `currency_id`, `training_lesson_id`, `user_id`, `created_at`, `updated_at`,
    # `training_type`, `sign_in_time`, `excuse_time`, `player_count_limit`, `is_open
    @training_lesson_realization = IndividualTrainingLessonRealization.create(date: Date.current, from: Time.at(12.hours),
      until: Time.at(14.hours), player_price_without_tax: 150, group_price_without_tax: 200, rental_price_without_tax: 100,
      calculation: :fixed_player_price, status: :scheduled, training_vat: @no_vat, rental_vat: @vat, currency: @currency,
      user: @user1, sign_in_time: Time.at(0), excuse_time: Time.at(0))

    # add some attendance
    @training_lesson_realization.present_coaches.build(salary_without_tax: 100, vat: @vat, currency: @currency, user: @user1)

    Attendance.create(training_lesson_realization: @training_lesson_realization, participation: :present, user: @user2, user_email: @user2.email, price_without_tax: 0)
    Attendance.create(training_lesson_realization: @training_lesson_realization, participation: :excused, user: @user3, user_email: @user3.email, price_without_tax: 0)
    Attendance.create(training_lesson_realization: @training_lesson_realization, participation: :unexcused, user: @user4, user_email: @user4.email, price_without_tax: 0)


    @training_lesson_realization_tax_payer = IndividualTrainingLessonRealization.create(date: Date.current, from: Time.at(12.hours),
      until: Time.at(14.hours), player_price_without_tax: 100, group_price_without_tax: 200, rental_price_without_tax: 100,
      calculation: :fixed_player_price, status: :scheduled, training_vat: @vat, rental_vat: @vat, currency: @currency,
      user: @user1, sign_in_time: Time.at(0), excuse_time: Time.at(0))

    # add some attendance
    Attendance.create(training_lesson_realization: @training_lesson_realization_tax_payer, participation: :present, user: @user2, user_email: @user2.email, price_without_tax: 0)
    Attendance.create(training_lesson_realization: @training_lesson_realization_tax_payer, participation: :excused, user: @user3, user_email: @user3.email, price_without_tax: 0)
    Attendance.create(training_lesson_realization: @training_lesson_realization_tax_payer, participation: :unexcused, user: @user4, user_email: @user4.email, price_without_tax: 0)

  end


  # WITHOUT TAX PAYMENT ###############################################################################################

  describe 'calculate_player_price_without_vat' do
    it 'I am not tax payer. Should return 100 and no warning if I have set
          * :fixed_player_price calculation
          * and 2 players pay player_price = 150 EUR (+ 0% VAT)
          * and rent is 100 EUR (+ 20% VAT)
          * and coach gets 100 EUR (+ 20% VAT)
          * and we are not TAX payers (training VAT = 0%)
          * so training is gainful => income = 300; costs = 120 + 120' do

      player_calc = @training_lesson_realization.calculate_player_price_without_vat
      player_calc[:player_price_without_vat].should eq 150
      player_calc[:balance].should eq 60
      player_calc[:is_gainful].should be_true
    end

    it 'I am not tax payer. Should return 100 and no warning if I have set
          * :split_the_costs calculation
          * and group_price = 300 EUR (+ 0% VAT)
          * and rent is 100 EUR (+ 20% VAT)
          * and coach gets 100 EUR (+ 20% VAT)
          * and we are not TAX payers (training VAT = 0%)
          * so training is gainful => income = 300; costs = 120 + 120' do

      @training_lesson_realization.group_price_without_tax = 300
      @training_lesson_realization.calculation = :split_the_costs
      @training_lesson_realization.save

      player_calc = @training_lesson_realization.calculate_player_price_without_vat
      player_calc[:player_price_without_vat].should eq 150
      player_calc[:balance].should eq 60
      player_calc[:is_gainful].should be_true
    end

    it 'I am not tax payer. Should return 300 and no warning if I have set
          * :fixed_player_price_or_split_the_costs calculation
          * and group_price = 600 EUR (+ 0% VAT)
          * and player_price = 150 EUR
          * and rent is 100 EUR (+ 20% VAT)
          * and coach gets 100 EUR (+ 20% VAT)
          * and we are not TAX payers (training VAT = 0%)
          * so training is gainful => income = MAX(300, 600); costs = 120 + 120' do

      @training_lesson_realization.group_price_without_tax = 600
      @training_lesson_realization.calculation = :fixed_player_price_or_split_the_costs
      @training_lesson_realization.save

      player_calc = @training_lesson_realization.calculate_player_price_without_vat
      player_calc[:player_price_without_vat].should eq 300
      player_calc[:balance].should eq 360
      player_calc[:is_gainful].should be_true
    end

    it 'I am not tax payer. Should return 300 and WARNING if I have set
          * :fixed_player_price_or_split_the_costs calculation
          * and group_price = 600 EUR (+ 0% VAT)
          * and player_price = 150 EUR
          * and rent is 600 EUR (+ 20% VAT)
          * and coach gets 100 EUR (+ 20% VAT)
          * and we are not TAX payers (training VAT = 0%)
          * so training is gainful => income = MAX(300, 600); costs = 720 + 120' do

      @training_lesson_realization.group_price_without_tax = 600
      @training_lesson_realization.rental_price_without_tax = 600
      @training_lesson_realization.calculation = :fixed_player_price_or_split_the_costs
      @training_lesson_realization.save

      player_calc = @training_lesson_realization.calculate_player_price_without_vat
      player_calc[:player_price_without_vat].should eq 300
      player_calc[:balance].should eq -240
      player_calc[:is_gainful].should be_false
      player_calc[:warning_message].should eq I18n.t('training_realization.model.lesson_not_gainful', amount: 240.0, currency: '€')

    end

    # WITH TAX PAYMENT ###############################################################################################

    it 'I am tax payer. Should return 150 and no warning if I have set
        * :fixed_player_price calculation
        * and 2 players pay player_price = 150 EUR (+ 20% VAT)
        * and rent is 100 EUR (+ 20% VAT)
        * and coach gets 100 EUR (+ 20% VAT)
        * and we are TAX payers (training VAT = 20%)
        * so training is gainful => income = 300; costs = 100 + 100' do

      @training_lesson_realization.training_vat = @vat

      player_calc = @training_lesson_realization.calculate_player_price_without_vat
      player_calc[:player_price_without_vat].should eq 150
      player_calc[:balance].should eq 100
      player_calc[:is_gainful].should be_true
    end

    it 'I am tax payer. Should return 150 and no warning if I have set
        * :split_the_costs calculation
        * and group_price = 300 EUR (+ 20% VAT)
        * and rent is 100 EUR (+ 20% VAT)
        * and coach gets 100 EUR (+ 20% VAT)
        * and we are TAX payers (training VAT = 20%)
        * so training is gainful => income = 300; costs = 100 + 100' do

      @training_lesson_realization.training_vat = @vat

      @training_lesson_realization.group_price_without_tax = 300
      @training_lesson_realization.calculation = :split_the_costs
      @training_lesson_realization.save

      player_calc = @training_lesson_realization.calculate_player_price_without_vat
      player_calc[:player_price_without_vat].should eq 150
      player_calc[:balance].should eq 100
      player_calc[:is_gainful].should be_true
    end

    it 'I am tax payer. Should return 300 and no warning if I have set
        * :fixed_player_price_or_split_the_costs calculation
        * and group_price = 600 EUR (+ 20% VAT)
        * and player_price = 150 EUR (+ 20% VAT)
        * and rent is 100 EUR (+ 20% VAT)
        * and coach gets 100 EUR (+ 20% VAT)
        * and we are TAX payers (training VAT = 20%)
        * so training is gainful => income = MAX(300, 600); costs = 100 + 100' do

      @training_lesson_realization.training_vat = @vat

      @training_lesson_realization.group_price_without_tax = 600
      @training_lesson_realization.calculation = :fixed_player_price_or_split_the_costs
      @training_lesson_realization.save

      player_calc = @training_lesson_realization.calculate_player_price_without_vat
      player_calc[:player_price_without_vat].should eq 300
      player_calc[:balance].should eq 400
      player_calc[:is_gainful].should be_true
    end

    it 'I am tax payer. Should return 300 and WARNING if I have set
        * :fixed_player_price_or_split_the_costs calculation
        * and group_price = 600 EUR (+ 0% VAT)
        * and player_price = 150 EUR
        * and rent is 600 EUR (+ 20% VAT)
        * and coach gets 100 EUR (+ 20% VAT)
        * and we are TAX payers (training VAT = 20%)
        * so training is gainful => income = MAX(300, 600); costs = 600 + 100' do

      @training_lesson_realization.training_vat = @vat

      @training_lesson_realization.group_price_without_tax = 600
      @training_lesson_realization.rental_price_without_tax = 600
      @training_lesson_realization.calculation = :fixed_player_price_or_split_the_costs
      @training_lesson_realization.save

      player_calc = @training_lesson_realization.calculate_player_price_without_vat
      player_calc[:player_price_without_vat].should eq 300
      player_calc[:balance].should eq -100
      player_calc[:is_gainful].should be_false
      player_calc[:warning_message].should eq I18n.t('training_realization.model.lesson_not_gainful', amount: 100.0, currency: '€')

    end

    it 'should return warning if we mix currencies' do
      @training_lesson_realization.currency = @currency2
      @training_lesson_realization.save

      player_calc = @training_lesson_realization.calculate_player_price_without_vat
      player_calc[:player_price_without_vat].should eq 150
      player_calc[:balance].should eq 0
      player_calc[:is_gainful].should be_false
      player_calc[:warning_message].should eq I18n.t('training_realization.model.can_not_check_calculation_different_currencies')
    end

  end
end
