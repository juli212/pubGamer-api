module Api::V1
  class SessionsController < BaseController
  	skip_before_action :require_login!, only: [:create]

  	def create
      # binding.pry
      user = User.find_for_authentication(session_params[:email])
      user ||= User.new
  		if user.authenticated?(session_params[:password])
  			auth_token = user.generate_auth_token
        # render json: user.custom_json
        render json: user,
    			only: [:id, :auth_token, :token_created_at]
      else
        user.invalidate_auth_token
        invalid_login_attempt
      end
  	end


  	def destroy
      user = current_user
  		user.invalidate_auth_token
  		head :ok
  	end


  	private

  	def session_params
  		params.require(:session).permit(:email, :password)
  	end

    def invalid_login_attempt
      render json: { errors: [ {detail: 'Authentication Failed'}]}, status: 401
    end

  end
end