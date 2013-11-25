json.array!(@variable_field_sports) do |variable_field_sport|
  json.extract! variable_field_sport, :name
  json.url variable_field_sport_url(variable_field_sport, format: :json)
end
