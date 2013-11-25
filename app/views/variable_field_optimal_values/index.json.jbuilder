json.array!(@variable_field_optimal_values) do |variable_field_optimal_value|
  json.extract! variable_field_optimal_value, :bottom_limit, :upper_limit, :source, :variable_field_id, :variable_field_sport_id, :variable_field_user_level
  json.url variable_field_optimal_value_url(variable_field_optimal_value, format: :json)
end
