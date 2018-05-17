module Api::V1
  class UsersController < BaseController
    include ActionController::HttpAuthentication::Token::ControllerMethods
    skip_before_action :require_login!, only: [:create]


    def show
      user = User.find_by(id: params[:id])
      render json: user.custom_json
    end


    def create
      @user = User.new(user_params)
      @user.encrypt_password(user_params[:password], user_params[:password_confirmation])
      # @user.image = Image.new(photo: user_params[:image])
      if @user.password_hash?
          binding.pry
          @user.build_image(photo: user_params[:image]) if user_params[:image] && user_params[:image] != 'null'
        if @user.save
          # puts 'Save'
          UserMailer.registration_confirmation(@user).deliver
        end
      end
    	render json: @user.custom_json
    end


    def confirm_email
      binding.pry
      user = User.find_by(confirmation_token: params[:id])
      # if user
        # user.confirm_email
      # end
      render json: user,
        include: ['favorites']
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
    	params.require(:user).permit(:id, :name, :email, :birthday, :bio, :password, :password_confirmation, :image)
    end

  end
end