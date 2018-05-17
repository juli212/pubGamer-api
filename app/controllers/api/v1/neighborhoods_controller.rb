module Api::V1
	class NeighborhoodsController < BaseController
		# before_action :authenticate_user!, except: [:index, :create]
		skip_before_action :require_login!, only: [:index, :show, :query]

		def index
			neighborhoods = Neighborhood.all()
			neighborhoods = neighborhoods.filter(query[:term]) if query[:term]
			render json: neighborhoods,
				only: [:name, :id]
		end

		# def create

		# end

		def show
			neighborhood = Neighborhood.find_by(id: params[:id])
			render json: neighborhood,
				only: [:name, :id]
		end

		private

		def query
			params.permit(:term)
		end

	end
end