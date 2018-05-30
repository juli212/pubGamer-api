class CreateUserVenues < ActiveRecord::Migration[5.1]
  def change
    create_table :user_venues do |t|
      t.integer :user_id, null: false
      t.integer :venue_id, null: false

      t.timestamps
    end
  end
end
