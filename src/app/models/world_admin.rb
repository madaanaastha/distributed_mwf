class WorldAdmin < ActiveRecord::Base
  def self.is_administrator?(world_uri, person_uri)
    require 'uri'
    require 'net/http'
    uri = Uri.get_record(world_uri)
    if (uri.is_external)
      w = World.find(uri.local_id)[:home_location_uri]
      arr = Uri.get_host_port(w)
      uri = URI::HTTP.build({host: arr[:host], port:arr[:port], path: '/world_admins/check_if_admin',
                            query:"world_uri=#{w}&user_uri=#{person_uri}"})
      request = Net::HTTP::Get.new(uri.request_uri(), initheader = {'Content-Type' =>'application/json'})
      response = Net::HTTP.new(arr[:host], arr[:port]).start {|http| http.request(request) }
      return eval(response.body)

    else
      if (world_uri==person_uri)
        return true
      end
      @users= where({world_uri: world_uri, admin_uri: person_uri})
      if (@users.empty?)

        uri = Uri.get_record(world_uri)
        model = Object.const_get(uri.uri_type)
        container_uri = model.find(uri.local_id).container_uri
        if (container_uri == world_uri)
          return false
        else
          return is_administrator?(container_uri, person_uri)
        end
      else
        return true
      end
    end

  end

  def self.has_visibility_privilege?(world_uri, person_uri)
    #TODO currently is a stub, check visibility privilege once privilege model is defined
    return is_administrator?(world_uri, person_uri)
  end

  def self.has_frame_level_privilege?(world_uri, person_uri)
    #TODO currently is a stub, check frame privilege once privilege model is defined
    return is_administrator?(world_uri, person_uri)
  end
end
