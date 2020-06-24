class Api::FlagsController < ApplicationController
	skip_before_action :verify_authenticity_token

	#POST su /flags
	def create
		current_user = getUserBySK(params[:apiKey])
    if !current_user.nil? && params.has_key?(:apiKey)
			flag = Flag.new(params[:flag].permit(:reason, :description, :url), user_id: current_user.id)

			if flag.valid?
				if ! flag.save
					render body: nil, status: 500
				end
			else
				render body: nil, status: 400
			end
		else
			render body: nil, status: 422
		end 
	end


	#DELETE su /flags/:id
	def destroy
		current_user = getUserBySK(params[:apiKey])
    if !current_user.nil? && params.has_key?(:apiKey)
            id = params[:id]
            
            if Flag.exists?(id)
                flag = Flag.find(id)

                if current_user.admin                    
                    if flag.destroy
                        render body: nil, status: 200
                    else
                        render body: nil, status: 500
                    end
                else
                    render body: nil, status: 422
                end
            else
                render body: nil, status: 404
            end
        else
            render body: nil, status: 422
        end
	end
end
