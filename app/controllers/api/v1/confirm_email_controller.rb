module Api::V1
	class ConfirmEmailController < BaseController
  	skip_before_action :require_login!, only: [:show]


    def show
      user = User.find_by(confirmation_token: params[:id])
      if user
        user.confirm_email
        email_confirmed
      else
        email_confirmation_failed
      end
    end
  
    private

    def email_confirmation_failed
        render json: { errors: [ {detail: 'Email authentication failed'}]}, status: 400
    end

    def email_confirmed
      render json: {}, status: 200
    end

  end
end