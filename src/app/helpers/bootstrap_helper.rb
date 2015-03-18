module BootstrapHelper
include WorldInstancesHelper
  def create_frame(hostname, port, name, username, email, password)
    if World.count.zero?
      concept = World.create_world_with_uri('Concept',nil,nil,'This is the root for the type hierarchy',nil, {:locked=>true},nil, nil, nil, hostname, port)

      uod = WorldInstance.create_world_instance_with_uri('Universe of Discourse', concept.world_uri, nil, 'This is the root for location hierarchy', nil, {:locked=>true}, nil, nil, {:default=> {{visibility: true, privilege: false, frame: false, structure: false, data: false}=>nil}}, hostname, port)
      concept.superclass_uri = concept.world_uri
      concept.container_uri = uod.world_instance_uri
      concept.save!

      uod.container_uri = uod.world_instance_uri
      uod.save!

      person = World.create_world_with_uri('Person', concept.world_uri, uod.world_instance_uri, 'This is the class for all person records', {birthdate: ''}, {locked: true}, nil, nil, nil, hostname, port)

      wi = WorldImport.new
      wi.import_to_uri = uod.world_instance_uri
      wi.import_from_uri = person.world_uri
      wi.save!

      SchemaTable.create_schema_with_uri('User', uod.world_instance_uri, 'home_profile_uri' ,{username:'string', email:'string', password_hash:'string', home_profile_uri:'Person', last_logged_in:'datetime'}, hostname, port) #user_role_type

      admin = add_user(hostname, port, name, username, email, password)

      world_admin = WorldAdmin.new
      world_admin.world_uri = uod.world_instance_uri
      world_admin.admin_uri = admin.world_instance_uri
      world_admin.save!
    end
  end
end
