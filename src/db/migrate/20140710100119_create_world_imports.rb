class CreateWorldImports < ActiveRecord::Migration
  def change
    create_table :world_imports do |t|
      t.string :import_to_uri
      t.string :import_from_uri

      t.timestamps
    end
  end
end
