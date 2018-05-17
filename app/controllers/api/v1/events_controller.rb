module Api::V1
	class EventsController < BaseController
		# before_action :authenticate_user!, except: [:index, :show, :create]
		skip_before_action :require_login!, only: [:index, :show, :create]

		def index
			events = Event.all
			render json: events,
			only: [:id, :title, :limit, :date, :time],
			include: {
				user: { only: [:id, :name]},
				games: {only: [:id, :name]}
			}
		end

		def show
			event = Event.find_by(id: params[:id])
			render json: event,
			only: [:id, :title, :limit, :description, :date, :time],
			include: { 
				user: { only: [:id, :name]},
				games: { only: [:id, :name]},
				guests: { only: [:id, :name]}
			}
		end

		def create
			event = Event.create(
				title: params[:title],
				venue_id: params[:venue_id],
				user_id: params[:user_id],
				limit: params[:limit],
				description: params[:description],
			)
			render json: event,
			only: [:id, :title, :limit, :description, :date, :time],
			include: { 
				user: { only: [:id, :name]},
				games: { only: [:id, :name]},
				guests: { only: [:id, :name]}
			}
		end
	end
end