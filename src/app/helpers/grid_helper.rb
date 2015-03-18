module GridHelper
  def create_concept_proxy concept, uod, host, port
    w = World.new
    w.home_location_uri = concept['uri']
    w.container_uri = uod['uri']
    w.container_name = uod['name']
    w.superclass_uri = concept['uri']
    w.superclass_name = concept['name']
    w.description = "Proxy for concept on #{concept['uri']}"
    w.name = 'Concept'
    w.version = concept['version']
    w.access_rules = ''
    w.access_rules = concept['access_rules'] unless concept['access_rules'].nil?
    w.save!

    w_uri = Uri.new
    w_uri.host = host
    w_uri.port = port
    w_uri.uri_type = 'World'
    w_uri.local_id = w.id
    w_uri.name = w.name
    w_uri.slug = Uri.get_slug(w.name)
    w_uri.is_external = true
    w_uri.save!

    w.world_uri = w_uri.get_uri
    w.save!

    return w.world_uri
  end

  def create_uod_proxy concept, uod, host, port
    w = WorldInstance.new
    w.home_location_uri = uod['uri']
    w.container_uri = uod['uri']
    w.superclass_uri = concept['uri']
    w.description = "Proxy for uod on #{uod['uri']}"
    w.name = 'Universe of Discourse'
    w.version = uod['version']
    w.access_rules = ''
    w.access_rules = uod['access_rules'] unless uod['access_rules'].nil?
    w.save!

    w_uri = Uri.new
    w_uri.host = host
    w_uri.port = port
    w_uri.uri_type = 'WorldInstance'
    w_uri.local_id = w.id
    w_uri.name = w.name
    w_uri.slug = Uri.get_slug(w.name)
    w_uri.is_external = true
    w_uri.save!

    w.world_instance_uri = w_uri.get_uri
    w.save!
    return w.world_instance_uri
  end

  def create_world_proxy world_hash, host, port
    w = World.new
    w.home_location_uri = world_hash['uri']
    w.container_uri = world_hash['container_uri']
    w.container_name = world_hash['container_name']
    w.superclass_uri = world_hash['superclass_uri']
    w.superclass_name = world_hash['superclass_name']
    w.description = "Proxy for #{world_hash['name']} on #{world_hash['uri']}"
    w.name = world_hash['name']
    w.version = world_hash['version']
    w.access_rules = ''
    w.access_rules = world_hash['access_rules'] unless world_hash['access_rules'].nil?
    w.save!

    w_uri = Uri.new
    w_uri.host = host
    w_uri.port = port
    w_uri.uri_type = 'World'
    w_uri.local_id = w.id
    w_uri.name = w.name
    w_uri.slug = Uri.get_slug(w.name)
    w_uri.is_external = true
    w_uri.save!

    w.world_uri = w_uri.get_uri
    w.save!

    return w.world_uri
  end

  def all_schemata uri
    require 'uri'
    require 'net/http'
    error = 0
    u = Uri.get_record(uri)
    schemata = []

    if (u.uri_type == "World" || u.uri_type == "WorldInstance")
      w = eval(u.uri_type).find_by_id(u.local_id)
      w_uri = uri
      uri = URI(uri)
      s_uri = w.superclass_uri
      begin
        # unless (w.home_location_uri.nil?)
          # puts w.home_location_uri.inspect
          # uri = URI::HTTP.build({host: uri.host, port: uri.port, path: '/grid/get_all_schemata',
          #                        query: "uri=#{w.home_location_uri}"})
          # register_request= Net::HTTP::Get.new(uri.request_uri(), initheader = {'Content-Type' => 'application/json'})
          # register_response = Net::HTTP.new(uri.host, uri.port).start { |http| http.request(register_request) }
          # if JSON.parse(register_response.body)[:error]!=0
          #   error = register_response.code
          #   break
          # else
          #   schemata.concat(JSON.parse(register_response.body)['relationships'])
          # end
        #else
        if(w.home_location_uri.nil?)
          s = SchemaTable.all.where(world_uri: w_uri)
          s.map() { |s| schemata<<{name: s.name, uri: s.uri, role_player_column_name: s.role_player_column_name,
                                   hash_store: s.hash_store, version: s.version} } unless s.nil?
          w_uri = w.superclass_uri
          w = World.find_by_world_uri(s_uri)
          s_uri = w.superclass_uri
        end
      end while (w_uri!=s_uri && w.home_location_uri.nil?)
    end
    return {relationships: schemata, error: error}
  end

end
