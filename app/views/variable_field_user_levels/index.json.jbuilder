json.array!(@variable_field_user_levels) do |variable_field_user_level|
  json.extract! variable_field_user_level, :name
  json.url variable_field_user_level_url(variable_field_user_level, format: :json)
end
