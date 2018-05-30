class CreateVibes < ActiveRecord::Migration[5.1]
  def change
    create_table :vibes do |t|
      t.string :name, null: false, unique: true, limit: 20

      t.timestamps
    end
  end
end
