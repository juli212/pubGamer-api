class UsersController < ApplicationController
	before_action :authenticate_user!, except: [:index, :show]


  def index
    users = User.all
    render json: users
  end

  def show
  	user = User.find_by(id: params[:id])
  	render json: user,
  		include: ['favorites']
  end

  def create
  	user = User.new(user_params)
  	render json: user,
  		include: ['favorites']
  end

  def favorite
  	user = User.find_by(id: params[:id])
  	venue = Venue.find_by(id: params[:venue_id])	
  	user.favorites.include?(venue) ? user.favorites.delete(venue) : user.favorites << venue
  	render json: user,
  		include: ['favorites']
  end

  # private

  # def user_params
  	# params.require(:user).permit(:id, :name, :image, :email, :birthday, :bio, :password_hash, :password_confirmation)
  # end

  # def favorite_params
  	# params.require(:user).permit(:id, :venue_id)
  # end

end