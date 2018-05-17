class CreateReviewVibes < ActiveRecord::Migration[5.1]
  def change
    create_table :review_vibes do |t|
      t.integer :review_id
      t.integer :vibe_id

      t.timestamps
    end
  end
end
