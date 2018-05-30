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
      # i = 12
      # current_page = params[:page] ? params[:page].to_i : 1
      # pages = venues.length % i === 0 ? venues.length / i : (venues.length / i) + 1
      # if current_page === 1 
      #   prev_page = nil
      # else
      #   prev_page = current_page - 1
      # end
      # if current_page === pages
      #   next_page = nil
      # else
      #   next_page = current_page + 1
      # end
      # paging = {
      #   first: "/venues?page=1",
      #   prev: prev_page ? "/venues?page=#{prev_page}" : nil,
      #   total_pages: pages.to_s,
      #   current_page: current_page.to_s,
      #   next: next_page ? "/venues?page=#{next_page}" : nil,
      #   last: "/venues?page=#{pages}"
      # }
      # binding.pry
      render json: custom_json_list(venues)
      # render json: custom_json_list(venues, paging, i)
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
      # binding.pry
	  	if venue.save
	  		venue.games << Game.find(game_array_params[:games]) if game_array_params[:games]
		  	render json: venue.custom_json
      elsif Venue.find_by(name: venue.name)
        # binding.pry
        venue = Venue.find_by(name: venue.name)
        duplicate_venue_attempt(venue.id)
      else
        binding.pry
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

    # def custom_json_list(venues, paging, per_page)
    def custom_json_list(venues) 
      list = venues.map do |venue|
        venue.custom_json
      end
      return list
      # venues = paginate list, per_page: per_page
      # {venues: venues, paging: paging}
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