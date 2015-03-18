class World < ActiveRecord::Base
  def self.create_world_with_uri (name, superclass_uri, container_uri, description, attrs, options, image, url, access_rules, host, port)
    w = World.new
    w.name = name
    w.superclass_uri = superclass_uri
    w.container_uri = container_uri
    w.description = description
    w.attrs = attrs.inspect
    w.options = options.inspect
    w.image = image
    w.url = url
    w.version = 1
    w.access_rules = access_rules.inspect
    w.save!

    w_uri = Uri.create_uri(host, port,'World', w.id, name, false)
    w.world_uri =w_uri.get_uri
    w.save!
    return w
  end

  def attrs_hash
    return eval(attrs)
  end

  def increment_version
    self.version += 1
    self.save
  end
end
