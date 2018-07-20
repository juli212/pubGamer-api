class VenueSerializer < ActiveModel::Serializer
  attributes :id, :name, :address, :lat, :lng, :avg_rating, :num_of_ratings, :is_favorite_of, :added, :created_at

  has_many :games
end
