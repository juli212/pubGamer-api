class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :bio, :birthday, :num_of_reviews, :num_venues_added, :profile_image, :num_of_favorites, :avg_review_rating

  has_many :favorites
end
