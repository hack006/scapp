json.array!(@variable_fields) do |variable_field|
  json.extract! variable_field, :name, :description, :unit, :higher_is_better, :is_numeric, :user_id, :variable_field_category_id
  json.url variable_field_url(variable_field, format: :json)
end
