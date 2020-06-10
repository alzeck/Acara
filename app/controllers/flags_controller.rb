class FlagsController < ApplicationController

	#GET su /flags
	def index
		if current_user.admin              
			@flags = Flag.all
		else
			render_422
		end
	end


	#GET su /flags/:id
	def show
		id = params[:id]
        
		if Flag.exists?(id)
			if current_user.admin                    
				@flag = Flag.find(id)
			else
				render_422
			end
        else
            render_404
        end
	end


	#GET su /flags/new
	def new
		if ! user_signed_in?
            render_422
        end
	end


	#POST su /flags
	def create
		if user_signed_in?
			flag = Flag.new(params[:flag].permit(:reason, :description, :url), user_id: current_user.id)

			if flag.valid?
				if ! flag.save
					render_500
				end
			else
				render_400
			end
		else
			render_422
		end 
	end


	#DELETE su /flags/:id
	def destroy
		if user_signed_in?
            id = params[:id]
            
            if Flag.exists?(id)
                flag = Flag.find(id)

                if current_user.admin                    
                    if flag.destroy
                        redirect_to flags_path
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
