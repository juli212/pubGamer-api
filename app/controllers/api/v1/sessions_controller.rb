module Api::V1
  class SessionsController < BaseController
  	skip_before_action :require_login!, only: [:create]

  	def create
      user = User.find_for_authentication(session_params[:email])
      user ||= User.new
  		if user.authenticated?(session_params[:password])
  			auth_token = user.generate_auth_token
        authorized_user(user)
      else
        user.invalidate_auth_token
        invalid_login_attempt
      end
  	end


    def current
      user = current_user
      if user
        authorized_user(user)
      else
        unauthorized
      end
    end


  	def destroy
      user = current_user
  		user.invalidate_auth_token
  		head :ok
  	end


  	private

  	def session_params
  		params.require(:user).permit(:email, :password)
  	end

    def invalid_login_attempt
      render json: { errors: [ {detail: 'Authentication Failed'}]}, status: 401
    end

    def unauthorized
      render json: {errors: [ {detail: 'Unauthorized'} ]}, status: 401
    end

    def authorized_user(user)
      render json: user,
        only: [:id, :auth_token],
        include: {}
    end

  end
end