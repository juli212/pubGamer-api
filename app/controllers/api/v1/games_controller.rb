module Api::V1
  class GamesController < BaseController
  	# before_action :authenticate_user!, except: [:index, :create]
  	# before_action :verify_authenticity_token, except: [:create]
		skip_before_action :require_login!, only: [:index, :show, :create]

    def index
    	games = Game.all
    	if limit_params[:limit]
    		# ids = 
    		games = Game.most_used(limit_params[:limit])
    		# games = Game.find(ids)
    	elsif query[:term]
    		games  = games.filter(query[:term])
    	else
	    	games = games.where(filter_params)
     	end
      render json: games,
      	only: [:name, :id]
    end

	  def create
	  	# binding.pry
	  	game = Game.find_or_create_by(game_params)
	  	if game.save
		  	render json: game,
		  		only: [:name, :id]
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