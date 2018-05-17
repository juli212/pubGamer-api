class CreateImages < ActiveRecord::Migration[5.1]
  def change
    create_table :images do |t|
    	t.belongs_to :imageable, polymorphic: true
    	t.attachment :photo

      t.timestamps
    end
  end
end
