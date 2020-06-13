class Api::ParticipationsController < ApplicationController

	#GET su /events/:event_id/participations
	def index
		event_id = params[:event_id]
		
		if Event.exists?(event_id)			
			if user_signed_in?
				part = Participation.where(user_id: current_user.id, event_id: event_id)[0]

				if part.nil?
					@participation = nil
				else
					@participation = part.value
				end
			else
				@participation = nil
			end			
		else
			render status: 404
		end
	end


	#POST su /events/:event_id/participations
	def create
		if user_signed_in?
			event_id = params[:event_id]
			
			if Event.exists?(event_id)
				participation = Participation.new(params[:participation].permit(:value), user_id: current_user.id, event_id: event_id)

				if participation.valid?
					if participation.save
						redirect_to api_event_path(Event.find(event_id))
					else
						render status: 500
					end
				else
					render status: 400
				end
			else
				render status: 404
			end
		else
			render status: 422
		end
	end


	#PATCH/PUT su /events/:event_id/participations/:id
	def update
		if user_signed_in?
			event_id = params[:event_id]
        
			if Event.exists?(event_id)
				participation_id = params[:id]
				event = Event.find(event_id)
				
				if Participation.exists?(participation_id)
					participation = Participation.find(participation_id)

					if current_user.id == participation.user_id || current_user.admin
						if participation.event_id == event_id
							participation.assign_attributes(params[:participation].permit(:value), user_id: current_user.id, event_id: event_id)
                    
							if participation.valid?
								if participation.save
									redirect_to api_event_path(event)
								else
									render status: 500
								end
							else
								render status: 400
							end
						else
							render status: 400
						end
					else
						render status: 422
					end
				else
					render status: 404
				end
			else
				render status: 404
			end
		else
			render status: 422
		end
	end


	#DELETE su /events/:event_id/participations/:id
	def destroy
		if user_signed_in?
			event_id = params[:event_id]
        
			if Event.exists?(event_id)
				participation_id = params[:id]
				
				if Participation.exists?(participation_id)
					participation = Participation.find(participation_id)

					if current_user.id == participation.user_id || current_user.admin
						if participation.event_id == event_id
							if participation.destroy
								redirect_to api_event_path(Event.find(event_id))
							else
								render status: 500
							end
						else
							render status: 400
						end
					else
						render status: 422
					end
				else 
					render status: 404
				end
			else
				render status: 404
			end
		else
			render status: 422
		end
    end
    
end
