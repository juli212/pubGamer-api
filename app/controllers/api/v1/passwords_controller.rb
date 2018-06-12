module Api::V1
	class PasswordsController < BaseController
 	skip_before_action :require_login!, only: [:forgot, :reset, :update]


		def forgot
			if update_password_params[:email].blank?
				return render json: {error: 'No user with that email found'}
			end

			user = User.find_by(email: update_password_params[:email].downcase)

			if user && user.email_confirmed?
				user.generate_password_token!
				UserMailer.reset_password(user).deliver
				render json: { status: 'ok'}, status: :ok
			else
				render json: { error: 'Email address not found'}, status: :not_found
			end
		end


		def reset
			if update_password_params[:token].blank?
				return render json: {error: 'Token not present'}
			end

			token = update_password_params[:token].to_s
			user = User.find_by(reset_password_token: token)

			if user && user.password_token_valid?
				render json: {status: 'ok'}, status: :ok
			else
				render json: {error: 'Link not valid'}, status: :not_found
			end
		end


		def update
			password = update_password_params[:password]
			confirmation = update_password_params[:confirmation]
			if !password.present? || !confirmation.present?
				return render json: {error: 'Password not present'}, status: :unprocessable_entity
			end

			binding.pry

			token = update_password_params[:token].to_s
			user = User.find_by(reset_password_token: token)

			if user && user.password_token_valid?
				if user.reset_password!(password, confirmation)
					render json: {status: 'ok'}, status: :ok
				else
					render json: {errors: current_user.errors.full_messages}, status: :unprocessable_entity
				end
			else
				render json: {error: 'Link not valid'}
			end
		end
		

		private

		def update_password_params
			params.permit(:email, :token, :password, :confirmation)
		end

	end
end
