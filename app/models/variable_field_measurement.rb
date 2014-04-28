class VariableFieldMeasurement < ActiveRecord::Base
  # =================== ASSOCIATIONS =================================
  belongs_to :measured_by, class_name: User, foreign_key: 'measured_by_id'
  belongs_to :measured_for, class_name: User, foreign_key: 'measured_for_id'
  belongs_to :variable_field
  belongs_to :training_lesson_realization

  # =================== VALIDATIONS ==================================
  validates :measured_at, presence: true
  validates :variable_field_id, presence: true
  validates :int_value, presence: true, if: 'variable_field && variable_field.is_numeric?'
  validates :int_value, numericality: true, if: 'variable_field && variable_field.is_numeric?'
  validates :string_value, presence: true, if: 'variable_field && !variable_field.is_numeric?'
  validates :measured_for_id, presence: true

  # =================== EXTENSIONS ===================================
  scope :latest_for_user, -> (user, limit) { where(measured_for_id: user).order('measured_at DESC').limit(limit) }

  # =================== METHODS ======================================

  # Obtain most recent measurements for players of specified coach user
  #
  # @param [User] user Coach
  # @param [Integer] limit Maximal number of measurements to obtain
  # @return [ActiveRecord::Relation] latest measurements
  def self.latest_for_coached_players_by(user, limit)
    coached_players_ids = user.get_my_relations_with_statuses('accepted', :my_players, 'accepted').map{ |c| c.user_to_id }

    VariableFieldMeasurement.
        where(measured_for_id: coached_players_ids).
        order('measured_at DESC').
        limit(limit)
  end

  # Find out statistics with comparison to historical measurements
  #
  # @param [DateTime] from_datetime
  # @return [Hash]
  #   @option :change_to_previous Change to previous measurement, positive value means grow, negative value reduction
  #   @option :change_to_average Change to AVG of previous measurements optionally limited by from date, positive value means grow, negative value reduction
  def stats_to_the_history(from_datetime = nil)
    if self.variable_field.is_numeric?
      out = { change_to_previous: 0, change_to_average: 0 , change_to_previous_percentage: 0, change_to_average_percentage: 0 }
      # get previous measurements
      previous_measurements = VariableFieldMeasurement.
          where('measured_at < ?', self.measured_at).
          where(measured_for: self.measured_for, variable_field: self.variable_field).
          order(measured_at: :desc)
      previous_measurements = previous_measurements.where('measured_at >= ?', from_datetime) unless from_datetime.nil?

      unless previous_measurements.empty?
        out[:change_to_previous] = self.int_value - previous_measurements.first.int_value
        out[:change_to_previous_percentage] = out[:change_to_previous] / previous_measurements.first.int_value * 100
        out[:change_to_average] = self.int_value - previous_measurements.average(:int_value)
        out[:change_to_average_percentage] = out[:change_to_average] / previous_measurements.average(:int_value) * 100
      end

      out
    else
      raise StandardError, 'Only numeric measurements can have statistics!'
    end
  end

end
