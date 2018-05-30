class ApplicationController < ActionController::API
	include ActionController::RequestForgeryProtection
	include ActionController::HttpAuthentication::Token::ControllerMethods
	# include ActionController::HttpAuthentication::Token::ControllerMethods
	# include ActionController::HttpAuthentication::Basic
	# include Rails::Pagination
	protect_from_forgery with: :null_session

end
	