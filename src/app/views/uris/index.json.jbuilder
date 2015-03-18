json.array!(@uris) do |uri|
  json.extract! uri, :id, :host, :port, :uri_type, :local_id, :name, :slug, :is_external
  json.url uri_url(uri, format: :json)
end
