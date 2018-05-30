module Api::V1
	class ReportsController < BaseController
  	# skip_before_action :require_login!, only: [:contact]


  	def create_inaccurate
  		user = current_user
  		venue = Venue.find_by(id: report_params[:venue_id])
  		report = Report.new(user: user, venue: venue, message: report_params[:message])
  		# binding.pry
  		if report.venue && report.user && report.save
  			ReportMailer.inaccurate_venue_report(report).deliver
  			report_sent
  		else
  			report_failed
  		end
  	end

  
    private

    def report_failed
        render json: { errors: [ {detail: 'Report failed'}]}, status: 400
    end

    def report_sent
      render json: {}, status: 200
    end

  	private

	  def report_params
	    params.permit(:venue_id, :message)
		end

  end
end
