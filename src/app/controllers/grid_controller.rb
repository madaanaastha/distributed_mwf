class GridController < ApplicationController
  include GridHelper

  def join_grid
    require 'uri'
    require 'net/http'

    host_port = request.host_with_port
    host = host_port.split(":").first
    port = host_port.split(":").last

    host_uri = URI(params[:url])
    uri = URI::HTTP.build({host: host_uri.host, port: host_uri.port, path: '/grid/join_grid_request'})
    request = Net::HTTP::Get.new(uri.request_uri(), initheader = {'Content-Type' => 'application/json'})
    response = Net::HTTP.new(host_uri.host, host_uri.port).start { |http| http.request(request) }
    if (response.code != :forbidden)
      data = JSON.parse(response.body)
      w_uri = create_concept_proxy data['concept'], data['uod'], host, port
      u_uri = create_uod_proxy data['concept'], data['uod'], host, port
      p_uri = create_world_proxy data['person'], host, port
      uri = URI::HTTP.build({host: host_uri.host, port: host_uri.port, path: '/grid/join_grid_response',
                             query: "concept_uri=#{w_uri}&uod_uri=#{u_uri}&person_uri=#{p_uri}"})
      register_request = Net::HTTP::Get.new(uri.request_uri(), initheader = {'Content-Type' => 'application/json'})
      register_response = Net::HTTP.new(host_uri.host, host_uri.port).start { |http| http.request(register_request) }
      if (register_response.code != :forbidden)
        redirect_to w_uri
      else
        c = Uri.get_record(w_uri)
        World.delete(c.local_id)
        Uri.delete(c)
        p = Uri.get_record(p_uri)
        World.delete(p.local_id)
        Uri.delete(p)
        u = Uri.get_record(u_uri)
        WorldInstance.delete(u.local_id)
        Uri.delete(u)
        render text: 'Could not register proxy.'
      end
    else
      render text: response.code
    end
  end

  def join_grid_request
    puts params.inspect
    concept = World.find_by_name('Concept')

    uod = WorldInstance.find_by_name('Universe of Discourse')
    person = World.find_by_name('Person')
    if (concept.home_location_uri.nil? && uod.home_location_uri.nil?)
      c = {uri: concept.world_uri, name:concept.name, version: concept.version, access_rules: concept.access_rules}
      u = {uri: uod.world_instance_uri, name:uod.name, version: uod.version, access_rules: uod.access_rules}
      p = {uri: person.world_uri, superclass_uri: person.superclass_uri, container_uri: person.container_uri, superclass_name: concept.name, container_name: uod.name, version: person.version, access_rules: person.access_rules, name: person.name}
      body = {concept: c, uod: u, person: p}.to_json
      render text: body
    else
      head status: :forbidden
    end
  end

  def join_grid_response
    concept = World.find_by_name('Concept')
    uod = WorldInstance.find_by_name('Universe of Discourse')
    person = World.find_by_name('Person')

    c = ProxyWorld.new
    c.world_uri = concept.world_uri
    c.proxy_world_uri = params['concept_uri']
    c.save!

    p = ProxyWorld.new
    p.world_uri = person.world_uri
    p.proxy_world_uri = params['person_uri']
    p.save!

    u = ProxyWorld.new
    u.world_uri = uod.world_instance_uri
    u.proxy_world_uri = params['uod_uri']
    u.save!

    if u.id.nil? || c.id.nil? || p.id.nil?
      head status: :forbidden
    else
      head status: :ok
    end
  end

  def create_proxy
    require 'uri'
    require 'net/http'
    @viewtype="create_proxy"
    @world = nil
    host_port = request.host_with_port
    if params[:world_uri]
      uri = URI(params[:world_uri])
      w = World.find_by_home_location_uri(uri.to_s)
      unless (w.nil?)
        uri = URI::HTTP.build({host: uri.host, port: uri.port, path: '/grid/get_world_proxy_details',
                               query: "world_uri=#{params[:world_uri]}&user_uri=#{session[:user_uri]}"})
        request = Net::HTTP::Get.new(uri.request_uri(), initheader = {'Content-Type' => 'application/json'})
        response = Net::HTTP.new(uri.host, uri.port).start { |http| http.request(request) }
        unless response.body.nil?
          data = JSON.parse(response.body)
          host = host_port.split(':').first
          port = host_port.split(':').last
          w = create_world_proxy data, host, port
          uri = URI::HTTP.build({host: uri.host, port: uri.port, path: '/grid/register_proxy',
                                 query: "proxy_uri=#{w}&world_uri=#{uri.to_s}"})
          register_request= Net::HTTP::Get.new(uri.request_uri())
          register_response = Net::HTTP.new(uri.host, uri.port).start { |http| http.request(register_request) }
          puts register_response.code.inspect
          unless register_response.code.to_s == "200"
            render text:'Could not register proxy. This proxy will not receive any updates.' and return
          else
            uri = URI::HTTP.build({host: uri.host, port: uri.port, path: '/grid/get_all_schemata',
                                   query: "world_uri=#{params[:world_uri]}&user_uri=#{session[:user_uri]}"})
            request = Net::HTTP::Get.new(uri.request_uri(), initheader = {'Content-Type' => 'application/json'})
            response = Net::HTTP.new(uri.host, uri.port).start { |http| http.request(request) }
            unless response.body.nil?
              data = JSON.parse(response.body)
              relationships = data["relationships"]
              relationships.each do |r|
                st = SchemaTable.new
                st.name = r["name"]
                st.version = r["version"]
                st.world_uri = w
                st.uri = r["uri"]
                st.role_player_column_name = r["role_player_column_name"]
                st.hash_store = r["hash_store"]
                st.save!
              end unless relationships.nil? or relationships.empty?
            end
            redirect_to w and return
          end
        else
          render text:'Could not create proxy due to insufficient rights, or uri is already a proxy'
        end
      else
        w = w.world_uri
      end
      redirect_to w
    end
  end

  def register_proxy
    c = ProxyWorld.new
    c.world_uri = params['world_uri']
    c.proxy_world_uri = params['proxy_uri']
    c.save!
    head status: :forbidden and return if(c.id.nil?)
    head status: :ok
  end

  def register_external_user

    #DataTuple.create_data_tuple(uod.get_uri(), user_schema.get_uri(), {:username=>username, :email=>email, :password_hash=>(password).crypt('salt'), :home_profile_uri=>"#{person_instance.world_instance_uri}",:last_logged_in=>""})
  end

  def get_world_proxy_details
    world_uri = params[:world_uri]
    user_uri = params[:user_uri]
    if (WorldAdmin.has_visibility_privilege?(world_uri, user_uri))
      uri = Uri.get_record(world_uri)
      if (uri.is_external || uri.uri_type!='World')
        head :forbidden
      else
        w = World.find(uri.local_id)
        superclass_uri = Uri.get_record(w.superclass_uri)
        container_uri = Uri.get_record(w.container_uri)
        superclass_name = superclass_uri.name
        container_name = container_uri.name
        body = {uri: w.world_uri, superclass_uri: w.superclass_uri, superclass_name:superclass_name,
                container_uri: w.container_uri, container_name: container_name,
                version: w.version, access_rules: w.access_rules, name: w.name}
        puts body.inspect
        render text: body.to_json and return
      end
    else
      head :forbidden
    end
  end

  def get_all_schemata
    uri = params[:world_uri]
    schemata = all_schemata(uri)
    render text:schemata[:relationships].to_json and return if(schemata[:error]==0)
    #render text:{status:schemata[:error]}.to_json and return
  end


end
