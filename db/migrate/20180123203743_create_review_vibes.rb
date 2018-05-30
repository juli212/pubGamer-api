class CreateReviewVibes < ActiveRecord::Migration[5.1]
  def change
    create_table :review_vibes do |t|
      t.integer :review_id, null: false
      t.integer :vibe_id, null: false

      t.timestamps
    end
  end
end
