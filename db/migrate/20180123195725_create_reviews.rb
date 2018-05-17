class CreateReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews do |t|
      t.text :content #max 200, not required
      t.string :day #integer if i want to use Enums
      t.integer :rating #1-5
      t.boolean :deleted, default: false
      t.integer :venue_id
      t.integer :user_id

      t.timestamps
    end
  end
end
