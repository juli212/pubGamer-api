class Vibe < ApplicationRecord
	has_many :review_vibes
	has_many :reviews, through: :review_vibes

	# enum name: [:chill, :divey, :pricey]
	# Change migration to integer to use Enums

end
