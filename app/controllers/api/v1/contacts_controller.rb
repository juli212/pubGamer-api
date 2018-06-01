module Api::V1
	class ContactsController < BaseController
  	skip_before_action :require_login!, only: [:create]


  	def create
  		user = current_user
  		contact = Contact.new(contact_params)
 			contact.user = user if user
  		if contact.save
  			ContactMailer.general_contact(contact).deliver
  			contact_sent
  		else
  			contact_failed
  		end
  	end

  
    private

    def contact_failed
        render json: { errors: [ {detail: 'Contact attempt failed'}]}, status: 400
    end

    def contact_sent
      render json: {}, status: 200
    end

	  def contact_params
	    params.permit(:email, :subject, :message)
		end

  end
end
