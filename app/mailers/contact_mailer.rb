class ContactMailer < ActionMailer::Base
	default from: 'pubgamerteam@gmail.com'


	def general_contact(contact)
		@email = contact.email
		@message = contact.message
		@subject = contact.subject
		mail(to: "pubgamerteam@gmail.com",
			subject: "PubGamer General Contact: #{@subject}")
	end

end
