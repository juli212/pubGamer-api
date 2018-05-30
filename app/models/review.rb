class Review < ApplicationRecord
	belongs_to :venue
  belongs_to :user
  has_many :review_vibes
  has_many :vibes, through: :review_vibes
	
  validates :venue_id, :user_id, :rating, presence: true
  validates_inclusion_of :rating, in: 1..5
  validates_length_of :content, maximum: 300, message: 'over character limit'

	# enum day: [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday]
	# Change Migration to integer to use Enums

	def display_date
		self.created_at.localtime.ctime
	end

	def numerical_date
		self.created_at.strftime("%b %d, '%y")
	end

	def author
		
	end

end
