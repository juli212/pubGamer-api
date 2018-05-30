class UserVenue < ApplicationRecord
	belongs_to :user
	belongs_to :venue

	validates :user_id, :venue_id, presence: true
end
