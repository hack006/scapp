json.array!(@user_relations) do |user_relation|
  json.extract! user_relation, :relation, :from_user_status, :to_user_status
  json.url user_relation_url(user_relation, format: :json)
end
