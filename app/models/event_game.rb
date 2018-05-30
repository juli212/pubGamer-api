class EventGame < ApplicationRecord
	belongs_to :event, null: false
	belongs_to :game, null: false

end
