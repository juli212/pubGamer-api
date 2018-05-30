class Api::V1::BaseController < ActionController::Base
	include ActionController::HttpAuthentication::Basic
	include ActionController::HttpAuthentication::Token::ControllerMethods
	include Rails::Pagination
	before_action :require_login!
	helper_method :user_signed_in?, :current_user

	def user_signed_in?
		current_user.present?
	end

	def require_login!
		return true if authenticate_token
		render json: { errors: [ { detail: 'Access denied'}]}, status: 401
	end

	def current_user
		@_current_user ||= authenticate_token
	end

	private

	def authenticate_token
		authenticate_with_http_token do |token, options|
			User.where(auth_token: token).where("token_created_at >= ?", 1.month.ago).first
		end
	end

end