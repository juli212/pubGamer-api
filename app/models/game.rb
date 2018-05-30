class Game < ApplicationRecord
	has_many :venue_games
	has_many :venues, through: :venue_games
	has_many :event_games
	has_many :events, through: :event_games

	validates :name, presence: true
	validates :name, uniqueness: true

	validates_length_of :name, maximum: 30, message: 'over character limit'


	def self.most_used(limit)
		a = []
		self.all.each do |game|
			a << {id: game.id, count: game.venues.length}
		end
		ordered_games =  a.sort_by { |hash| hash[:count] }.last(limit.to_i)
		ids =[]
		ordered_games.each do |game|
			ids << game[:id]
		end
		self.find(ids)
	end

	def self.filter(term)
		where("name ILIKE :term", term: "%#{term.downcase}%")
	end

end
