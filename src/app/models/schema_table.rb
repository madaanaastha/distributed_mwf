class SchemaTable < ActiveRecord::Base
  def self.create_schema_with_uri schema_name, world_uri, role_player, schema , host, port
    st = SchemaTable.new
    st.name = schema_name
    st.version = 1
    st.world_uri = world_uri
    st.role_player_column_name = role_player
    st.hash_store = schema.inspect
    st.save!

    st_uri = Uri.create_uri(host, port, 'SchemaTable', st.id, schema_name, false)
    st.uri =st_uri.get_uri
    st.save!
    return st
  end
end
