class CreateVenueGames < ActiveRecord::Migration[5.1]
  def change
    create_table :venue_games do |t|
      t.integer :game_id
      t.integer :venue_id

      t.timestamps
    end
    add_index :venue_games, [:game_id, :venue_id], unique: true
  end
end
