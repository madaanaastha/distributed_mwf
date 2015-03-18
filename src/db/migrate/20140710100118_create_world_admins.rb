class CreateWorldAdmins < ActiveRecord::Migration
  def change
    create_table :world_admins do |t|
      t.string :world_uri
      t.string :admin_uri

      t.timestamps
    end
  end
end
