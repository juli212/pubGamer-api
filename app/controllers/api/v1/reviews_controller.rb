# require 'will_paginate/array'
module Api::V1
  class ReviewsController < BaseController
  	# before_action :authenticate_user!, except: [:index, :create, :new]
  	# wrap_parameters :venue, include: [:name, :address, :lat, :lng, :neighborhood, :games]
  	skip_before_action :require_login!, only: [:index, :create, :show]

    def index
    	reviews = Review.where(venue_id: params[:venue_id])
    	# binding.pry
      render json: reviews,
      	only: [:id, :content, :rating, :day],
      	methods: [:display_date],
      	include: {
      		vibes: { only: [:name, :id]}
      	}
    end

	  def create
	  	review = Review.new(review_params)
	  	review.venue = Venue.find_by(id: params[:venue_id])
	  	review.user_id = 1
	  	if review.save
	  		params[:vibes].each do |v|
	  			review.vibes << Vibe.find_by(name: v)
	  		end
	  	end
	  	# binding.pry
	  	render json: review,
	  		only: [:id, :content, :rating, :day],
	  		methods: [:display_date],
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