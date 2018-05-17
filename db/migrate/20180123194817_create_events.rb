class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string 	:title
      t.text 		:description
      t.date 		:date
      t.time 		:time
      t.integer :limit
      t.boolean	:deleted, default: false
      t.integer	:user_id, default: 1, null: true
      t.integer :venue_id, null: true


      t.timestamps
    end
  end
end
