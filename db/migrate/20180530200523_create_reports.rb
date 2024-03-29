class CreateReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reports do |t|

    	t.integer 	:cat, null: false, default: 0
    	t.integer 	:user_id
    	t.integer 	:venue_id
    	t.text			:message, null: false

      t.timestamps
    end
  end
end
