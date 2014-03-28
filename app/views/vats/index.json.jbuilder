json.array!(@vats) do |vat|
  json.extract! vat, :name, :percentage_value, :is_time_limited, :start_of_validity, :end_of_validity
  json.url vat_url(vat, format: :json)
end
