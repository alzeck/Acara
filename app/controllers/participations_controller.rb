class ParticipationsController < ApplicationController

	# JSON
	#POST su /events/:event_id/participations
	def create
		if user_signed_in?
			event_id = params[:event_id]
			
			if Event.exists?(event_id)
				participation = Participation.new(params[:participation].permit(:value), user_id: current_user.id, event_id: event_id)
			
				if participation.save
					redirect_to event_path(Event.find(event_id))
				else
					#flash[:notice] = participation.errors.full_messages
					redirect_to event_path(Event.find(event_id))
				end
			else
				#flash[:notice] = 'Event does not exist'
				redirect_to root_path
			end
		else
			#flash[:notice] = "User not signed in"
			redirect_to root_path
		end
	end


	#PATCH/PUT su /events/:event_id/participations/:id
	def update
		if user_signed_in?
			event_id = params[:event_id]
        
			if Event.exists?(event_id)
				participation_id = params[:id]
				event = Event.find(event_id)
				
				if Participation.exists?(participation_id) && (current_user.id == Participation.find(participation_id).user_id || current_user.admin) && Participation.find(participation_id).event_id == event_id
					participation = Participation.find(participation_id)

					if participation.update(params[:participation].permit(:value), user_id: current_user.id, event_id: event_id)
						redirect_to event_path(event)
					else
						#flash[:notice] = participation.errors.full_messages
						redirect_to event_path(event)
					end
				else 
					#flash[:notice] = 'Cannot update this participation'
					redirect_to event_path(event)
				end
			else
				#flash[:notice] = 'Event does not exist'
				redirect_to root_path
			end
		else
			#flash[:notice] = "User not signed in"
			redirect_to root_path
		end
	end


	#DELETE su /events/:event_id/participations/:id
	def destroy
		if user_signed_in?
			event_id = params[:event_id]
        
			if Event.exists?(event_id)
				participation_id = params[:id]
				
				if Participation.exists?(participation_id) && (current_user.id == Participation.find(participation_id).user_id || current_user.admin) && Participation.find(participation_id).event_id == event_id
					Participation.find(participation_id).destroy
					redirect_to event_path(Event.find(event_id))
				else 
					#flash[:notice] = 'Cannot delete this participation'
					redirect_to event_path(Event.find(event_id))
				end
			else
				#flash[:notice] = 'Event does not exist'
				redirect_to root_path
			end
		else
			#flash[:notice] = "User not signed in"
			redirect_to root_path
		end
	end

end
