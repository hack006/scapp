json.array!(@training_lessons) do |training_lesson|
  json.extract! training_lesson, :description, :day, :from, :until, :calculation, :from_date, :until_date, :player_price_without_tax, :group_price_without_tax, :rental_price_without_tax, :training_vat_id, :rental_vat, :regular_training_id
  json.url training_lesson_url(training_lesson, format: :json)
end
