require 'will_paginate/array'
module Api::V1
  class VenuesController < BaseController
  	skip_before_action :require_login!, only: [:index, :show]


    def index 
      venues = Venue.with_games(game_array_params[:games]).query(query_params[:query]).uniq

      if !map_bounds_params.empty?
        venues = venues.select { |venue| venue.inLatLngBounds(
          bounds[:lat_min],
          bounds[:lat_max],
          bounds[:lng_min],
          bounds[:lng_max])
        }
      end
      venues = venues.sort_by { |v| -v.avg_rating }
      render json: venues
    end


    def show
    	venue = Venue.find_by(id: params[:id])
      render json: venue
    end


    def new
    	@venue = Venue.new
    	render json: @venue
    end


	  def create
	  	venue = Venue.new(venue_params)
	  	if venue.save
	  		venue.games << Game.find(game_array_params[:games]) if game_array_params[:games]
        render json: venue
		  	# render json: venue.custom_json
      elsif Venue.find_by(name: venue.name)
        venue = Venue.find_by(name: venue.name)
        duplicate_venue_attempt(venue.id)
      else
        errors = venue.errors
        venue_create_failed
      end
	  end


	  def favorite
	  	venue = Venue.find_by(id: params[:id])
	  	user = current_user
	  	favorites = user.favorites
     	favorites && favorites.include?(venue) ? favorites.delete(venue) : favorites << venue
	  	render json: favorites
	  end


		private

    def bounds
      return map_bounds_params
    end

	  def venue_params
	    params.require(:venue).permit(:name, :address, :lat, :lng, :neighborhood, :image, :place_id)
		end
  
  	def filtering_params
  		params.permit(:name, :id)
  	end

  	def game_array_params
  		params.permit(:games => [])
  	end

    def query_params
      params.permit(:query)
    end

    def map_bounds_params
      params.permit(:lat_min, :lat_max, :lng_min, :lng_max)
    end

    def custom_json_list(venues) 
      list = venues.map do |venue|
        venue.custom_json
      end
      return list
    end

    def duplicate_venue_attempt(id)
      render json: {
        errors: [ {detail: 'Venue already exists in database'} ],
        venue_id: id}, status: 409
    end

    def venue_create_failed
      render json: { errors: [ {detail: 'Error processing request'}]}, status: 400
    end

  end
end