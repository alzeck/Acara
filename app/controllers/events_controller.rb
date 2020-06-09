class EventsController < ApplicationController    
    
    #GET su /events/:id
    def show
        id = params[:id]
        
        if Event.exists?(id)
            @event = Event.find(id)

            @interested = Participation.where(:event_id => id, :value => "i").length
            @going = Participation.where(:event_id => id, :value => "p").length
            @tags = HasTag.where(:event_id => id)
            #@comments = Comment.where(:event_id => id)
        else
            #flash[:notice] = "Event does not exist"
            redirect_to root_path
        end
	end
    
    
    #GET su /events/new
	def new
	end
    
    
    #POST su /events
    def create
        event = Event.new(params[:event].permit(:where, :cords, :start, :end, :title, :description, :cover, :gallery))
        
        if event.save
            tags = params[:event].permit(:tags);
            tags = tags.scan(/#\w+/).flatten.map(&:downcase).uniq
            
            for elem in tags
                tg = Tag.where(:name => elem)[0]

				if tg.nil?   
                    tg = Tag.new(name: elem)
                    if tg.save
                        HasTag.create(event_id: event.id, tag_id: tg.id)
                    else
                        #flash[:notice] = tg.errors.full_messages
                    end
                else
                    HasTag.create(event_id: event.id, tag_id: tg.id)  
				end
			end

            redirect_to event_path(event)
        else
            #flash[:notice] = event.errors.full_messages
            redirect_to root_path
        end
    end

	
	#GET su /events/:id/edit
    def edit
        id = params[:id]
        
        if Event.exists?(id)
            @event = Event.find(id)
            @tags = HasTag.where(:event_id => id)
        else
            #flash[:notice] = 'Event does not exist'
            redirect_to root_path
        end
	end
    
    
	#PUT o PATCH su /events/:id
	def update
        id = params[:id]
        
        if Event.exists?(id)
            event = Event.find(id)

            if event.update(params[:event].permit(:where, :cords, :start, :end, :title, :description, :cover, :gallery), modified: true)
                has_tags = HasTag.where(:event_id => id)
                for elem in has_tags
                    if !elem.destroy
                        #flash[:notice] = elem.errors.full_messages
                    end
                end
            
                tags = params[:event].permit(:tags);
                tags = tags.scan(/#\w+/).flatten.map(&:downcase).uniq
                
                for elem in tags
                    tg = Tag.where(:name => elem)[0]

                    if tg.nil?   
                        tg = Tag.new(name: elem)
                        if tg.save
                            HasTag.create(event_id: event.id, tag_id: tg.id)
                        else
                            #flash[:notice] = tg.errors.full_messages
                        end
                    else
                        HasTag.create(event_id: event.id, tag_id: tg.id)  
                    end
                end
                
				redirect_to event_path(event)
		    else
		        #flash[:notice] = event.errors.full_messages
		        redirect_to event_path(event)
		    end
		else
            #flash[:notice] = 'Event does not exist'
            redirect_to root_path
		end
	end
	
    
	#DELETE su /events/:id
	def destroy
		id = params[:id]
		
		if Event.exists?(id)
            event = Event.find(id)

            comments = Comment.where(:event_id => id)
			for elem in comments
				if !elem.destroy
					#flash[:notice] = elem.errors.full_messages
           			redirect_to event_path(event)
				end
            end

            has_tags = HasTag.where(:event_id => id)
			for elem in has_tags
				if !elem.destroy
					#flash[:notice] = elem.errors.full_messages
           			redirect_to event_path(event)
				end
			end            
            
			participations = Participation.where(:event_id => id)
			for elem in participations
				if !elem.destroy
					#flash[:notice] = elem.errors.full_messages
           			redirect_to event_path(event)
				end
			end 

            event.cover.purge_later
            event.gallery.purge_later
            
			if event.destroy
				redirect_to root_path
			else
				#flash[:notice] = event.errors.full_messages
           		redirect_to event_path(event)
           	end
		else
            #flash[:notice] = 'Event does not exist'
            redirect_to root_path
		end
	end

end
