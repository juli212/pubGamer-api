class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts do |t|
    	
    	t.integer 	:cat, null: false, default: 0
    	t.string 		:email, null: false
    	t.text			:message, null: false
    	t.string		:subject, default: ''
    	t.integer		:user_id

      t.timestamps
    end
  end
end
