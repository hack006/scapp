json.array!(@variable_field_categories) do |variable_field_category|
  json.extract! variable_field_category, :name, :rgb, :description, :user_id
  json.url variable_field_category_url(variable_field_category, format: :json)
end
