class CreateEventGames < ActiveRecord::Migration[5.1]
  def change
    create_table :event_games do |t|
      t.integer :game_id
      t.integer :event_id

      t.timestamps
    end
    add_index :event_games, [:game_id, :event_id], unique: true
  end
end
