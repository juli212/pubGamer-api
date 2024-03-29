class AddEmailConfirmationToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :email_confirmed, :boolean, default: false
    add_column :users, :confirmation_token, :string
  end
end
