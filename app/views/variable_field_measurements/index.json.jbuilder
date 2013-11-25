json.array!(@variable_field_measurements) do |variable_field_measurement|
  json.extract! variable_field_measurement, :measured_at, :locality, :string_value, :int_value
  json.url variable_field_measurement_url(variable_field_measurement, format: :json)
end
