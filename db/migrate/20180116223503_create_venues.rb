class CreateVenues < ActiveRecord::Migration[5.1]
  def change
    create_table :venues do |t|
      t.string  :name, null: false, length: 255
      t.string  :address, null: false, length: 255
      t.string  :lat, null: false
      t.string  :lng, null: false
      t.string  :place_id, unique: true, null: false
      t.boolean :deleted, default: false, null: false
      t.integer :user_id, default: 1, null: false

      t.timestamps
    end
  end
end
