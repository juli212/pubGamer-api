class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.text :body, null: false, length: 300
      t.boolean :deleted, default: false, null: false
      t.integer :event_id, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
