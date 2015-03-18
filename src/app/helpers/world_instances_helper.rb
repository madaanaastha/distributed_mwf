module WorldInstancesHelper
  def add_user hostname, port, name, username, email, password

    person = Uri.find_by_slug('Person')
    uod = Uri.find_by_slug('UniverseofDiscourse')
    user_schema = Uri.find_by_slug('User')

    person_instance = WorldInstance.create_world_instance_with_uri(name, person.get_uri(), uod.get_uri(), "I am #{name}",nil,{locked:true}, nil, nil, nil, hostname, port)

    DataTuple.create_data_tuple(uod.get_uri(), user_schema.get_uri(), {:username=>username, :email=>email, :password_hash=>(password).crypt('salt'), :home_profile_uri=>"#{person_instance.world_instance_uri}",:last_logged_in=>""})

    return person_instance
  end
end
