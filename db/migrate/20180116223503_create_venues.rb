class CreateVenues < ActiveRecord::Migration[5.1]
  def change
    create_table :venues do |t|
      t.string  :name
      t.string  :address
      t.string  :lat
      t.string  :lng
      t.string  :place_id
      t.boolean :deleted, default: false
      t.integer :neighborhood_id
      t.integer :user_id, default: 1

      t.timestamps
    end
  end
end
