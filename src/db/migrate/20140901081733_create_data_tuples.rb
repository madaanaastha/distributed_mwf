class CreateDataTuples < ActiveRecord::Migration
  def change
    create_table :data_tuples do |t|
      t.string :world_uri
      t.string :schema_uri
      t.text :data_store
      t.timestamps
    end
  end
end
