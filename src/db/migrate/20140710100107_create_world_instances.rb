class CreateWorldInstances < ActiveRecord::Migration
  def change
    create_table :world_instances do |t|
      t.string :name
      t.string :superclass_uri
      t.string :container_uri
      t.text :description
      t.text :attrs
      t.text :options
      t.string :world_instance_uri
      t.string :home_location_uri
      t.string :image
      t.string :url
      t.text :access_rules
      t.integer :version

      t.timestamps
    end
  end
end
