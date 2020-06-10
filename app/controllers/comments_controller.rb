class CommentsController < ApplicationController

	# JSON
	# GET su /events/:event_id/comments
	def index
		event_id = params[:event_id]
		
		if Event.exists?(event_id)
			#@event = Event.find(event_id)

			commNoReply = Comment.where(event_id: event_id, previous_id: nil).sort_by(&:created_at)

			@comments = []
			for elem in commNoReply
				@comments << { "comment" => elem, "replies" => Comment.where(event_id: event_id, previous_id: elem.id).sort_by(&:created_at) }
			end
		else
			#flash[:notice] = 'Event does not exist'
            redirect_to root_path
		end	
	end

  
	#POST su /events/:event_id/comments
	def create
		if user_signed_in?
			event_id = params[:event_id]
			
			if Event.exists?(event_id)
				comment = Comment.new(params[:comment].permit(:content, :previous_id), user_id: current_user.id, event_id: event_id)
			
				if comment.save
					redirect_to event_path(Event.find(event_id))
				else
					#flash[:notice] = comment.errors.full_messages
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


  	#PATCH/PUT su /events/:event_id/comments/:id
  	def update
		if user_signed_in?
			event_id = params[:event_id]
        
			if Event.exists?(event_id)
				comment_id = params[:id]
				event = Event.find(event_id)
				
				if Comment.exists?(comment_id) && (current_user.id == Comment.find(comment_id).user_id || current_user.admin) && Comment.find(comment_id).event_id == event_id
					comment = Comment.find(comment_id)

					if comment.update(params[:comment].permit(:content, :previous_id), user_id: current_user.id, event_id: event_id)
						redirect_to event_path(event)
					else
						#flash[:notice] = event.errors.full_messages
						redirect_to event_path(event)
					end
				else 
					#flash[:notice] = 'Cannot update this comment'
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


	#DELETE su /events/:event_id/comments/:id
	def destroy
		if user_signed_in?
			event_id = params[:event_id]
        
			if Event.exists?(event_id)
				comment_id = params[:id]
				
				if Comment.exists?(comment_id) && (current_user.id == Comment.find(comment_id).user_id || current_user.admin) && Comment.find(comment_id).event_id == event_id
					Comment.find(comment_id).destroy
					redirect_to event_path(Event.find(event_id))
				else 
					#flash[:notice] = 'Cannot delete this comment'
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
