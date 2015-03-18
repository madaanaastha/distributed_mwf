json.array!(@worlds) do |world|
  json.extract! world, :id, :name, :superclass_uri_id, :container_uri_id, :description, :attrs, :options, :world_uri_id, :home_location_uri_id, :image, :url, :access_rules, :version
  json.url world_url(world, format: :json)
end
