class ReportMailer < ActionMailer::Base
	default from: 'pubgamerteam@gmail.com'


	def inaccurate_venue_report(report)
		@user = report.user
		@message = report.message
		@venue = report.venue
		# binding.pry
		mail(to: "pubgamerteam@gmail.com",
			subject: "PubGamer Inaccurate Venue Report")
	end

end
