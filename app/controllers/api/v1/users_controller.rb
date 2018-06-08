module Api::V1
  class UsersController < BaseController
    include ActionController::HttpAuthentication::Token::ControllerMethods
    skip_before_action :require_login!, only: [:create, :update]

    def show
      user = User.find_by(id: params[:id])
      if user
        render json: user.custom_json
      else
        no_user_found
      end
    end



    def create
      @user = User.new(user_params)
      binding.pry
      @user.encrypt_password(user_params[:password], user_params[:password_confirmation])
      if @user.save
        UserMailer.registration_confirmation(@user).deliver
      	render json: @user.custom_json
      else
        errors = @user.errors.full_messages
        registration_failed(errors)
      end
    end


    def update
      user = current_user
      if !user || !user === User.find_by(id: update_params[:id]) 
        unauthorized
      else
        user.update_attributes(update_params)
        user.build_image(photo: update_params[:image]) if update_params[:image] && update_params[:image] != 'null'
        if user.save
          render json: user.custom_json
        else
          update_failed
        end
      end
    end


    def favorite
    	user = current_user
    	venue = Venue.find_by(id: params[:venue_id])	
    	user.favorites.include?(venue) ? user.favorites.delete(venue) : user.favorites << venue
    	render json: user,
    		include: ['favorites']
    end

    private

    def user_params
    	params.require(:user).permit(:email, :password, :password_confirmation)
    end


    def update_params
      params.require(:user).permit(:id, :name, :birthday, :bio, :password, :image)
    end


    def update_failed
      render json: { errors: [ {detail: 'Update Failed'}]}, status: 500
    end

    def no_user_found
      render json: { errors: [ {detail: 'User Not Found'}]}, status: 404
    end

    def registration_failed(errors)
      render json: { errors: errors}, status: 400
    end

    def unauthorized
      render json: {errors: [ {detail: 'Unauthorized'} ]}, status: 401
    end

  end
end