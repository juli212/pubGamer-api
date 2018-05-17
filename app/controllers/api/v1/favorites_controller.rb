module Api::V1
  class FavoritesController < BaseController
    include ActionController::HttpAuthentication::Token::ControllerMethods
    skip_before_action :require_login!, only: [:index]
	
		def index
			# binding.pry
			user = User.find_by(id: params[:user_id])
			favorites = user.favorites
			render json: custom_favorites_json(favorites)
		end

		private

		def custom_favorites_json(venues)
			list = venues.map do |venue|
				venue.custom_json
			end
			list
		end

	end
end