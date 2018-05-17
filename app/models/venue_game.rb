class VenueGame < ApplicationRecord
	belongs_to :game
	belongs_to :venue
end
