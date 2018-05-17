class UserMailer < ActionMailer::Base
	default from: 'pubgamerteam@gmail.com'


	def registration_confirmation(user)
		@user = user
		# binding.pry
		mail(to: "#{user.name} <#{user.email}>", subject: "PubGamer Registration Confirmation")
	end

end
