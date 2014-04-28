json.array!(@training_lesson_realizations) do |training_lesson_realization|
  json.extract! training_lesson_realization, :date, :from, :until, :player_price_without_tax, :group_price_without_tax, :rental_price_without_tax, :calculation, :status, :note, :training_vat_id, :rental_vat_id, :currency_id, :training_lesson_id, :user_id
  json.url training_lesson_realization_url(training_lesson_realization, format: :json)
end
