json.array!(@regular_trainings) do |regular_training|
  json.extract! regular_training, :name, :description, :public, :user_id
  json.url regular_training_url(regular_training, format: :json)
end
