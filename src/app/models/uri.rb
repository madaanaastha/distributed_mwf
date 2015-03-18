class Uri < ActiveRecord::Base
  def self.get_slug(name)
    name = name.gsub(/[^0-9A-Za-z]/, '')
    if Uri.find_by_slug(name).nil?
      return name
    else
      r = Uri.where("slug like '#{name}%'").count
      return "#{name}#{r}"
    end

  end
  def self.create_uri (host, port, uri_type, local_id, name, is_external)
    u = Uri.new
    u.host = host
    u.port = port
    u.uri_type = uri_type
    u.local_id = local_id
    u.name = name
    u.slug = get_slug(name)
    u.is_external = is_external
    u.save!
    return u
  end

  def get_uri
    if (port.nil?)
      return "http://#{host}/uris/#{slug}"
    else
      return "http://#{host}:#{port}/uris/#{slug}"
    end
  end

  def self.get_record(record_uri)
    host_uri = URI(record_uri)
    slug = host_uri.path.split('/').last
    return where(slug: slug).first
  end

  def self.get_host_port(uri)
    u = URI(uri)
    return {host: u.host, port: u.port};
  end
end
