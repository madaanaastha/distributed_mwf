class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :event_type_id
      t.string :world_uri
      t.text :privilege_id

      t.timestamps
    end
  end
end
