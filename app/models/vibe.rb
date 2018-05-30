class Vibe < ApplicationRecord
	has_many :review_vibes
	has_many :reviews, through: :review_vibes

	validates :name, presence: true
	validates :name, uniqueness: true
	validates_length_of :name, maximum: 20, message: "over character limit"
end
