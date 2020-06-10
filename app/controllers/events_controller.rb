class EventsController < ApplicationController    
    
    #GET su /events/:id
    def show
        id = params[:id]
        
        if Event.exists?(id)
            @event = Event.find(id)
        else
            render_404
        end
	end
    
    
    #GET su /events/new
    def new
        if ! user_signed_in?
            render_422
        end
	end
    
    
    #POST su /events
    def create
        if user_signed_in?
            tags = createTags( params[:event].permit(:tags) )
            event = Event.new(params[:event].permit(:where, :cords, :start, :end, :title, :description, :cover, :gallery), user_id: current_user.id)
        
            if event.valid?
                if event.save
                    createHasTags(tags, event)
                    redirect_to event_path(event)
                else
                    render_500
                end
            else
                render_400
            end
        else
            render_422
        end      
    end

	
	#GET su /events/:id/edit
    def edit
        if user_signed_in?
            id = params[:id]

            if Event.exists?(id)
                @event = Event.find(id)
                if !( current_user.id == @event.user_id || current_user.admin )
                    render_422
                end
            else
                render_404
            end
        else
            render_422
        end
	end
    
    
	#PUT o PATCH su /events/:id
	def update
        if user_signed_in?
            id = params[:id]
            
            if Event.exists?(id)
                event = Event.find(id)

                if current_user.id == event.user_id || current_user.admin
                    destroyHasTags(event)
                    tags = createTags( params[:event].permit(:tags) )

                    event.assign_attributes(params[:event].permit(:where, :cords, :start, :end, :title, :description, :cover, :gallery), modified: true)
                    
                    if event.valid?
                        if event.save
                            createHasTags(tags, event)
                            redirect_to event_path(event)
                        else
                            render_500
                        end
                    else
                        render_400
                    end
                else
                    render_422
                end
            else
                render_404
            end
        else
            render_422
        end
	end
	
    
	#DELETE su /events/:id
	def destroy
        if user_signed_in?
            id = params[:id]
            
            if Event.exists?(id)
                event = Event.find(id)

                if current_user.id == event.user_id || current_user.admin
                    destroyComments(event)
                    destroyHasTags(event)
                    destroyParticipations(event)
                    
                    event.cover.purge_later
                    event.gallery.purge_later
                    
                    if event.destroy
                        redirect_to root_path
                    else
                        render_500
                    end
                else
                    render_422
                end
                
            else
                render_404
            end
        else
            render_422
        end
	end

end
