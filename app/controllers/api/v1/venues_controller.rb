require 'will_paginate/array'
module Api::V1
  class VenuesController < BaseController
  	# before_action :authenticate_user!, except: [:index, :show, :create, :new]
  	skip_before_action :require_login!, only: [:index, :show]


    def index 
    	venues = Venue.where(filtering_params)
      if game_array_params[:games] && query_params[:query]
        venues = venues.search_and_filter(game_array_params[:games], query_params[:query])
      else
        venues = venues.game_array_filter(game_array_params[:games]) if game_array_params[:games]
        venues = venues.full_search(query_params[:query]) if query_params[:query]
      end
      if !map_bounds_params.empty?
        bounds = map_bounds_params

        venues = venues.select { |venue| venue.inLatLngBounds(
          bounds[:lat_min],
          bounds[:lat_max],
          bounds[:lng_min],
          bounds[:lng_max])
        }
      end
      venues = venues.sort_by { |v| -v.avg_rating }
      render json: custom_json_list(venues)
    end


    def show
    	venue = Venue.find_by(id: params[:id])
    	render json: venue.custom_json
    end


    def new
    	@venue = Venue.new
    	render json: @venue
    end


	  def create
	  	venue = Venue.new(venue_params)
	  	if venue.save
	  		venue.games << Game.find(game_array_params[:games]) if game_array_params[:games]
		  	render json: venue.custom_json
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