class Review < ApplicationRecord
	belongs_to :venue
  belongs_to :user
  has_many :review_vibes
  has_many :vibes, through: :review_vibes
	
	# enum day: [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday]
	# Change Migration to integer to use Enums

	def display_date
		self.created_at.localtime.ctime
	end

	def author
		
	end

end
