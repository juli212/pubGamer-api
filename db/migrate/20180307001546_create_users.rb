class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.text 		:bio
      t.string	:name
      t.string 	:email
      t.date    :birthday
      t.string  :password_hash
      t.boolean :deleted, default: false

      t.timestamps
    end
  end
end
