require 'will_paginate/array'
module Api::V1
  class VenuesController < BaseController
  	# before_action :authenticate_user!, except: [:index, :show, :create, :new]
  	skip_before_action :require_login!, only: [:index, :create, :show]


    def index 
    	venues = Venue.where(filtering_params)
      # binding.pry
      if game_array_params[:games] && query_params[:query]
        venues = venues.search_and_filter(game_array_params[:games], query_params[:query])
      else
        venues = venues.game_array_filter(game_array_params[:games]) if game_array_params[:games]
        venues = venues.full_search(query_params[:query]) if query_params[:query]
      end
      # binding.pry
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
	  	venue.neighborhood = Neighborhood.find_or_create_by(name: params[:neighborhood])
	  	if venue.save
	  		venue.games << Game.find(game_array_params[:games]) if game_array_params[:games]
			end
		  	render json: venue.custom_json	
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
	    params.require(:venue).permit(:name, :address, :lat, :lng, :neighborhood, :image)
		end
  
  	def filtering_params
  		params.permit(:name, :id, :neighborhood_ids => [])
  	end

  	def game_array_params
  		params.permit(:games => [])
  	end

  	def game_params
  		params.permit(:games)
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
      list
    end

  end
end