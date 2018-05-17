class Neighborhood < ApplicationRecord
	has_many :venues
	has_many :events, through: :venues

	def self.filter(term)
		where("name ILIKE :term", term: "%#{term.downcase}%")
	end

end
