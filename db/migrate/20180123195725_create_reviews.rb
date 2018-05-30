class CreateReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews do |t|
      t.text :content, limit: 300 #max 200, not required
      # t.string :day #integer if i want to use Enums
      t.integer :rating, inclusion: 1..5, null: false #1-5
      t.boolean :deleted, default: false, null: false
      t.integer :venue_id, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
