class DisplayController < ApplicationController
  include WorldsHelper
  protect_from_forgery

  def index
    display_uri = Uri.find_by_slug(params[:slug])
    if display_uri.nil?
      render layout: 'display/error'
    end
    case display_uri.uri_type
      when 'World'
        @world = World.find_by_id(display_uri.local_id)
        @superclass = Uri.get_record(@world.superclass_uri)
        @container = Uri.get_record(@world.container_uri)
        @rules_list = get_all_access_rules @world.world_uri, @world.container_uri
        session[:rules] = @rules_list
        render 'world'
      when 'SchemaTable'
        render 'schema_table'
      when 'WorldInstance'
        @world_instance = WorldInstance.find_by_id(display_uri.local_id)
        @superclass = Uri.get_record(@world_instance.superclass_uri)
        if(@superclass.is_external)
          @s_world = World.find_by_id(@superclass.local_id)
        end
        @container = Uri.get_record(@world_instance.container_uri)
        if(@container.is_external)
          @c_world = eval(@container.uri_type).find_by_id(@container.local_id)
        end
        @rules_list = get_all_access_rules @world_instance.world_instance_uri, @world_instance.container_uri
        render 'world_instances'
    end
  end
end