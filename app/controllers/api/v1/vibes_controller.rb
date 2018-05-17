module Api::V1
  class VibesController < BaseController
  	# before_action :authenticate_user!, except: [:index, :create, :new]
		skip_before_action :require_login!, only: [:index]

    def index
    	# reviews = Review.where(venue_id: params[:venue_id])
    	# binding.pry
    	vibes = Vibe.all
      render json: vibes,
      	only: [:name]
    end


		private

	  def vibe_params
	    params.require(:vibe).permit(:name)
		end

  end
end