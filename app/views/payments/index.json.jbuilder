json.array!(@payments) do |payment|
  json.extract! payment, :amount, :status, :currency_id, :received_by_id
  json.url payment_url(payment, format: :json)
end
