# require 'will_paginate/array'
module Api::V1
  class ReviewsController < BaseController
  	skip_before_action :require_login!, only: [:index]

    def index
    	reviews = Review.where(venue_id: params[:venue_id])
      render json: reviews,
      	only: [:id, :content, :rating, :day, :user_id],
      	methods: [:numerical_date],
      	include: {
      		vibes: { only: [:name, :id]}
      	}
    end

	  def create
	  	review = Review.new(review_params)
	  	review.venue = Venue.find_by(id: params[:venue_id])
	  	review.user_id = current_user.id
	  	if review.save
	  		params[:vibes].each do |v|
	  			review.vibes << Vibe.find_by(name: v)
	  		end
	  	end
	  	render json: review,
	  		only: [:id, :content, :rating, :day, :user_id],
	  		methods: [:numerical_date],
	  		include: {
	  			vibes: { only: [:name, :id]}
	  		}
	  end

		private

	  def review_params
	    params.require(:review).permit(:venue_id, :content, :day, :rating, :vibes => [])
		end

  end
end