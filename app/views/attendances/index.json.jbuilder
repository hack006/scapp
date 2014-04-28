json.array!(@attendances) do |attendance|
  json.extract! attendance, :participation, :price_without_tax, :player_change, :training_lesson_realization_id, :user_id, :payment_id
  json.url attendance_url(attendance, format: :json)
end
