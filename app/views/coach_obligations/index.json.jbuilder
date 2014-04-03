json.array!(@coach_obligations) do |coach_obligation|
  json.extract! coach_obligation, :hourly_wage_without_vat, :role, :vat_id, :currency_id, :user_id, :regular_training_id
  json.url regular_training_coach_obligation_url(@regular_training, coach_obligation, format: :json)
end
