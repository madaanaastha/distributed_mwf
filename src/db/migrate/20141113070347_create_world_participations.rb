class CreateWorldParticipations < ActiveRecord::Migration
  def change
    create_table :world_participations do |t|
      t.string :participating_world_uri
      t.string :container_table_uri
      t.string :container_world_uri
      t.boolean :verified
    end
  end
end
