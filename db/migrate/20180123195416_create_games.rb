class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.string :name, null: false, unique: true, length: 30

      t.timestamps
    end
  end
end
