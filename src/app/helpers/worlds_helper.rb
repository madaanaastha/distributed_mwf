module WorldsHelper
  def get_all_attributes uri
    world_uri = Uri.get_record(uri)
    #TODO check proxy
    world = World.find(world_uri.local_id)
    attrs = world.attrs_hash
  end

  def get_all_imports world_uri, superclass_uri
    imports = [world_uri]
    w = Uri.get_record(world_uri)
    unless (w.is_external?)
      begin
        imports << superclass_uri
        world_imports = WorldImport.all.where(import_to_uri: world_uri)
        world_imports.map { |import| imports<<import.import_from_uri }
        superclass = World.find(Uri.get_record(superclass_uri).local_id)
        world_uri = superclass.world_uri
        superclass_uri = superclass.superclass_uri
        w = Uri.get_record(world_uri)
      end while (superclass_uri!=world_uri && !w.is_external)
    end
    imports = imports.uniq
    return imports
  end

  def get_all_instances world_uri
    i =[]
    w = Uri.get_record(world_uri)
    unless (w.is_external)
      world_uris = [world_uri]
      begin
        world_uri = world_uris.pop
        w = Uri.get_record(world_uri)
        unless (w.is_external)
          instances = WorldInstance.all.where(superclass_uri: world_uri)
          instances.map { |inst| i<<{name: inst.name, uri: inst.world_instance_uri} } unless instances.empty?
          i = i.uniq
          subclasses = World.all.where(superclass_uri: world_uri).pluck(:world_uri)
          world_uris.concat(subclasses)
          world_uris = world_uris.uniq
        end
      end while (!(world_uris.empty?))
    end
    #call privilege method to check if world instance is in a world closed to the user
    return i
  end

  def get_all_tables world_uri, superclass_uri
    tables = []
    w = Uri.get_record(world_uri)
    unless (w.is_external)
      begin
        t = SchemaTable.all.where(:world_uri => world_uri)
        t.map { |table| tables<<{uri: table.uri, name: table.name} }
        superclass = World.find(Uri.get_record(superclass_uri).local_id)
        world_uri = superclass.world_uri
        superclass_uri = superclass.superclass_uri
        world_uri_record = Uri.get_record(world_uri)
        if(world_uri_record.is_external)
          break
        end
      end while (superclass_uri!=world_uri)
    end
    tables = tables.uniq
    return tables
  end

  def get_all_roles world_uri, superclass_uri
    tables = []
    w = Uri.get_record(world_uri)
    unless (w.is_external)
      begin
        t = SchemaTable.all.where(:world_uri => world_uri).where.not(:role_player_column_name => nil)
        t.map { |table| tables<<{uri: table.uri, name: table.name, type_uri: table.world_uri, location_uri: World.find_by_world_uri(table.world_uri).container_uri} }
        superclass = World.find(Uri.get_record(superclass_uri).local_id)
        world_uri = superclass.world_uri
        superclass_uri = superclass.superclass_uri
      end while (superclass_uri!=world_uri)
    end
    tables = tables.uniq
    return tables
  end

  def get_all_access_rules world_uri, container_uri
    w = Uri.get_record(world_uri)
    rules = {}
    unless (w.is_external)
      # begin
      while true
        arr = find_world_or_world_instance(world_uri)
        world = arr[0]
        access_rules = eval (world.access_rules)
        if (access_rules != nil)
          access_rules.each do |k, v|
            name = world.name.delete(' ')
            rules[k.to_s + '(' + name.to_s + ')'] = v
          end
        end
        if container_uri == world_uri
          break
        end
        array = find_world_or_world_instance(container_uri)
        container = array[0]
        if(container.nil?)
          break
        end
        if array[1] == "WorldInstance"
          world_uri = container.world_instance_uri
        else
          world_uri = container.world_uri
        end
        container_uri = container.container_uri
      end
    end
    return rules
  end

  def find_world_or_world_instance world_uri
    world = Uri.get_record(world_uri)
    if world.uri_type == 'World'
      found_world = World.find_by_world_uri(world_uri)
    else
      found_world = WorldInstance.find_by_world_instance_uri(world_uri)
    end
    arr = []
    arr[0] = found_world
    arr[1] = world.uri_type
    return arr
  end

end