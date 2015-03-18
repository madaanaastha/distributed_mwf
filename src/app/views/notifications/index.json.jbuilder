json.array!(@notifications) do |notification|
  json.extract! notification, :id, :event_type_id, :world_uri_id, :privilege_id
  json.url notification_url(notification, format: :json)
end
