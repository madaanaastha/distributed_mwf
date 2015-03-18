class CreateProxyWorlds < ActiveRecord::Migration
  def change
    create_table :proxy_worlds do |t|
      t.string :world_uri
      t.string :proxy_world_uri

      t.timestamps
    end
  end
end
