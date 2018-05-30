class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.date    :birthday
      t.text 		:bio, length: 300
      t.string	:name, length: 255
      t.string  :password_hash, null: false
      t.string 	:email, null: false, unique: true, length: 255
      t.boolean :deleted, default: false, null: false

      t.timestamps
    end
  end
end
