json.array!(@proxy_worlds) do |proxy_world|
  json.extract! proxy_world, :id, :world_uri_id, :proxy_world_uri_id
  json.url proxy_world_url(proxy_world, format: :json)
end
