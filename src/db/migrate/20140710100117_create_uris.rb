class CreateUris < ActiveRecord::Migration
  def change
    create_table :uris do |t|
      t.string :host
      t.integer :port
      t.string :uri_type
      t.integer :local_id
      t.string :name
      t.string :slug
      t.boolean :is_external

      t.timestamps
    end
  end
end
