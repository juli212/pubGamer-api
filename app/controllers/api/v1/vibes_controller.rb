module Api::V1
  class VibesController < BaseController
		skip_before_action :require_login!, only: [:index]

    def index
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