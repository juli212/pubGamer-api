class Venue < ApplicationRecord
  # include Filterable

	belongs_to :user
	
  has_many :reviews
	has_many :venue_games
	has_many :games, through: :venue_games
	has_many :images, as: :imageable, dependent: :destroy
	has_many :user_venues
  has_many :favorited_by, through: :user_venues, source: :user
	has_many :reports
	accepts_nested_attributes_for :images

	validates :name, :address, :lat, :lng, :place_id, :user_id, presence: true
	validates :address, uniqueness: true
	validates :name, :address, length: {maximum: 255, message: 'over character limit'}
	# validates :name, format: {
	# 	with: /\A[\d\sa-zA-Z_\.\,\-\+\!\?]+\z/,
	# 	message: "Invalid characters: Acceptable characters are A-Z, a-z, 0-9"
	# }
  # validates :bio, length: { maximum: 500 }

  scope :with_games, ->(name) {
  	joins(:games).where(games: {name: name}) if name.present?
  }

  scope :query, ->(query) {
  	joins(:games).where("venues.name ILIKE :term OR venues.address ILIKE :term OR games.name ILIKE :term OR to_tsvector(venues.name || ' ' || venues.address || ' ' || games.name) @@ to_tsquery('#{query.split.join(' | ')}')", term: "%#{query.downcase}%")	if query.present?
  }

  scope :by_avg_rating, -> {
		left_joins(:reviews).group('venues.id').order('AVG(reviews.rating) desc NULLS LAST')
  }

  scope :by_reviews, -> {
  	left_joins(:reviews).group('venues.id').order('COUNT(reviews.venue_id) desc')
  }

  scope :by_favorites, -> {
  	left_joins(:user_venues).group('venues.id').order('COUNT(user_venues.venue_id) desc')
  }

  scope :by_date, -> {
  	order(:created_at)
  }

  # scope :inside_lat, ->(bounds) {
  # 	where(float_lat: bounds[:lat_min].to_f..bounds[:lat_max].to_f) if bounds.present?
  # }

  # scope :inside_lng, ->(bounds) {
  # 	where(float_lng: bounds[:lng_min].to_f..bounds[:lng_max].to_f) if bounds.present?
  # }

  # scope :min_lat, ->(min) { where(lat > min) if min.present? }
  # scope :max_lat, ->(max) { where(lat < max) if max.present? }
  # scope :min_lng, ->(min) { where(lng > min) if min.present? }
  # scope :max_lng, ->(max) { where(lng < max) if max.present? }

  def float_lat
  	self.lat.to_f
  end

  def float_lng
  	self.lng.to_f
  end

	def num_of_ratings
		self.reviews.where(deleted: :false).length
	end

	def sum_ratings
		self.reviews.pluck(:rating).reduce(:+)
	end

	def avg_rating
		if self.num_of_ratings > 0
			avg = self.sum_ratings/self.num_of_ratings.to_f
			avg = avg.round(2)
		else
			avg = 0
		end
		avg
	end

	def self.game_array_filter(params)
		self.joins(:games).where(games: {name: params}).uniq
	end


	def self.game_filter(params)
		ary = params.split(',')
		self.joins(:games).where(games: {name: ary}).uniq
	end


	def self.search_and_filter(filter_params, search_query)
		filtered_venues = self.game_array_filter(filter_params)
		searched_venues = self.full_search(search_query)
		venues = filtered_venues & searched_venues
		venues.uniq
	end


	def self.full_search(param)
		term = param.gsub(/[^\d\sa-zA-Z_\.\,\-\+\!\?]/, "")
		venues = self.single_phrase_search(term) + self.multi_word_search(term)
		venues.uniq
	end

	def self.multi_word_search(term)
		words = term.split.join(' | ')
		self.joins(:games).where("to_tsvector(venues.name || ' ' || venues.address || ' ' || games.name) @@ to_tsquery('#{words}')")		
	end


	def self.single_phrase_search(term)
		self.joins(:games).where("venues.name ILIKE :term OR venues.address ILIKE :term OR games.name ILIKE :term", term: "%#{term.downcase}%").uniq
	end


	def inLatLngBounds(lat_min, lat_max, lng_min, lng_max)
		lat = self.lat
		lng = self.lng
		(lat_min.to_f..lat_max.to_f).include?(self.lat.to_f) && (lng_min.to_f..lng_max.to_f).include?(self.lng.to_f)
	end

	def images
    Image.where(
    	imageable_id: self.id,
    	imageable_type: 'Venue'
    )
  end

  def custom_json
    { id: self.id,
      name: self.name,
      address: self.address,
      lat: self.lat,
      lng: self.lng,
      avg_rating: self.avg_rating,
      games: self.games_for_json,
      num_of_ratings: self.reviews.length,
      favorites: self.favorited_by.length,
      added: self.created_at.to_date
    }
  end

  def games_for_json
  	games = self.games.map do |game|
    	{ id: game.id,
      	name: game.name
    	}
  	end
  	games
  end

  def added
  	return self.created_at.to_date
  end

  def is_favorite_of
  	return self.favorited_by.length
  end

  def custom_json_list(venues)
  	list = venues.map do |venue|
  		venue.custom_json
  	end
  	list
  end

end