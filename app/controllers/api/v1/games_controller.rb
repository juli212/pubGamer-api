module Api::V1
  class GamesController < BaseController
		skip_before_action :require_login!, only: [:index, :show, :create]

    def index
    	games = Game.all
    	if limit_params[:limit]
    		games = Game.most_used(limit_params[:limit])
    	elsif query[:term]
    		games  = games.filter(query[:term])
    	else
	    	games = games.where(filter_params)
     	end
     	render json: games
    end

	  def create
	  	game = Game.find_or_create_by(name: game_params[:name].downcase)
	  	if game.save
	  		render json: game
			end
	  end

		private

	  def game_params
	    params.require(:game).permit(:name)
		end

		def filter_params
			params.permit(:name => [])
		end

		def limit_params
			params.permit(:limit)
		end

		def query
			params.permit(:term)
		end

  end
end