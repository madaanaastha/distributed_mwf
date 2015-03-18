json.array!(@world_admins) do |world_admin|
  json.extract! world_admin, :id, :world_uri_id, :admin_uri_id
  json.url world_admin_url(world_admin, format: :json)
end
