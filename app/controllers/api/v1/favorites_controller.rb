module Api::V1
  class FavoritesController < BaseController
    include ActionController::HttpAuthentication::Token::ControllerMethods
    # skip_before_action :require_login!, only: [:index]


		def index
			if params[:user_id]
				user = User.find_by(id: params[:user_id])
				favorites = user.favorites
				render json: custom_favorites_json(favorites)
			else
				user = current_user
				favorites = user.favorites
				render json: favorite_id_list(favorites)
			end
		end


		def create
			user = current_user
			venue = Venue.find_by(id: params[:venue_id])
			fav = UserVenue.new(venue: venue, user: user)
			if fav.save
				render json: favorite_id_list(user.favorites)
			else
				update_failed
			end
		end


		def destroy
			user = current_user
			fav = UserVenue.find_by(venue_id: params[:id], user_id: user.id)
			if fav
				fav.delete
				render json: favorite_id_list(user.favorites)
			else
				unauthorized
			end
		end


		private

		def custom_favorites_json(venues)
			list = venues.map do |venue|
				venue.custom_json
			end
			list
		end

		def favorite_id_list(venues)
			return venues.pluck(:id)
		end

    def unauthorized
      render json: {errors: [ {detail: 'Unauthorized'} ]}, status: 401
    end

    def update_failed
      render json: { errors: [ {detail: 'Update Failed'}]}, status: 500
    end

	end
end