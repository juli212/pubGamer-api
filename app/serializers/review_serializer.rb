class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :content, :rating, :user_id, :numerical_date

  has_many :vibes
end
