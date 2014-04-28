json.array!(@present_coaches) do |present_coach|
  json.extract! present_coach, :salary_without_tax, :vat_id, :currency_id, :user_id, :training_lesson_realization_id, :supplementation
  json.url present_coach_url(present_coach, format: :json)
end
