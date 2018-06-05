class AddUniqueIndexToUserVenues < ActiveRecord::Migration[5.1]
  def change
  	add_index :user_venues, [:user_id, :venue_id], unique: true
  end
end
