json.array!(@world_imports) do |world_import|
  json.extract! world_import, :id, :import_to_uri, :import_from_uri
  json.url world_import_url(world_import, format: :json)
end
