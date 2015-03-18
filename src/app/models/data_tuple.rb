class DataTuple < ActiveRecord::Base
  def self.create_data_tuple( world_uri,schema_uri, tuple)
    dt = DataTuple.new
    dt.world_uri =world_uri
    dt.schema_uri = schema_uri
    dt.data_store = tuple.inspect
    dt.save!

    return dt
  end

  def data_hash
    return eval(data_store)
  end
end
