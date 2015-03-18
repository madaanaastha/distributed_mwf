class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :event_type
      t.datetime :date_time
      t.string :world_uri
      t.text :privilege_id
      t.string :user_uri

      t.timestamps
    end
  end
end
