module Api::V1
	class ConfirmEmailController < BaseController
  	skip_before_action :require_login!, only: [:show]


    def show
      user = User.find_by(confirmation_token: params[:id])
      if user
        user.confirm_email
      end
      render json: user,
      	only: [:id, :email_confirmed]
      	# include: ['favorites']
    end
  
  end
end