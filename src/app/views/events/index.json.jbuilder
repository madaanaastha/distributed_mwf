json.array!(@events) do |event|
  json.extract! event, :id, :event_type, :date_time, :world_uri_id, :privilege_id, :user_uri_id
  json.url event_url(event, format: :json)
end
