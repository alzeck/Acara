class Api::CommentsController < ApplicationController
    # cambiare render_### -> render status: ###
    # redirect_to cosa_path -> redirect_to api_cosa_path
    #POST su /events/:event_id/comments
	def create
		if user_signed_in?
			event_id = params[:event_id]
			
			if Event.exists?(event_id)
				comment = Comment.new(params[:comment].permit(:content, :previous_id), user_id: current_user.id, event_id: event_id)
			
				if comment.valid?
					if comment.save
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


  	#PATCH/PUT su /events/:event_id/comments/:id
  	def update
		if user_signed_in?
			event_id = params[:event_id]
        
			if Event.exists?(event_id)
				comment_id = params[:id]
				event = Event.find(event_id)
				
				if Comment.exists?(comment_id)
					comment = Comment.find(comment_id)

					if current_user.id == comment.user_id || current_user.admin
						if comment.event_id == event_id
							comment.assign_attributes(params[:comment].permit(:content, :previous_id), user_id: current_user.id, event_id: event_id)
                    
							if comment.valid?
								if comment.save
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


	#DELETE su /events/:event_id/comments/:id
	def destroy
		if user_signed_in?
			event_id = params[:event_id]
        
			if Event.exists?(event_id)
				comment_id = params[:id]
				
				if Comment.exists?(comment_id)
					comment = Comment.find(comment_id)

					if current_user.id == comment.user_id || current_user.admin
						if comment.event_id == event_id
							destroyReplies(comment)

							if comment.destroy
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
