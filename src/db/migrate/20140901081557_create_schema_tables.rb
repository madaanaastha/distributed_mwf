class CreateSchemaTables < ActiveRecord::Migration
  def change
    create_table :schema_tables do |t|
      t.string :world_uri
      t.string :name
      t.string :uri
      t.string :role_player_column_name
      t.integer :version
      t.text :hash_store
      t.timestamps
    end
  end
end
