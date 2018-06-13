class UserMailer < ActionMailer::Base
	default from: 'pubgamerteam@gmail.com'


	def registration_confirmation(user)
		@user = user
		mail(to: "#{user.name} <#{user.email}>", subject: "PubGamer Registration Confirmation")
	end


	def reset_password(user)
		@user = user
		mail(to: "#{user.name} <#{user.email}>", subject: "Reset PubGamer Password")
	end

end
