json.array!(@world_instances) do |world_instance|
  json.extract! world_instance, :id, :name, :superclass_uri_id, :container_uri_id, :description, :attrs, :options, :world_instance_uri_id, :home_location_uri_id, :image, :url, :access_rules, :version
  json.url world_instance_url(world_instance, format: :json)
end
