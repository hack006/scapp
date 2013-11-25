json.array!(@organizations) do |organization|
  json.extract! organization, :name, :location, :description
  json.url organization_url(organization, format: :json)
end
