class FlagsController < ApplicationController

  #GET su /flags/new
  #Si basa sui parametri passati in get:
  # GET /flags/new?type=event&id=EVENT_ID
  # GET /flags/new?type=user&id=USER_ID
  # GET /flags/new?type=comment&id=COMMENT_ID
  def new
    if user_signed_in?
      tipo = params[:type]
      id = params[:id].to_i # 0 if id not present
      if %w(event user comment).include?(params[:type]) && id != 0
        #check if both params are valid
        flaggedEvent = nil
        flaggedComment = nil
        flaggedUser = nil
        # everything is nil unless is proven wrong

        if tipo == "event"
          flaggedEvent = id
        elsif tipo == "user"
          flaggedUser = id
        elsif tipo == "comment"
          flaggedComment = id
        end

        @flag = Flag.new(flaggedEvent_id: flaggedEvent,
                         flaggedComment_id: flaggedComment,
                         flaggedUser_id: flaggedUser)
      else
        render_400
      end
    else
      render_401
    end
  end

  #POST su /flags
  def create
    if user_signed_in?
      par = params[:flag].permit(:reason, :description, :flaggedEvent,
                                 :flaggedComment, :flaggedUser)
      @flag = Flag.new(reason: par[:reason], description: par[:description],
                      flaggedEvent_id: par[:flaggedEvent], flaggedComment_id: par[:flaggedComment],
                      flaggedUser_id: par[:flaggedUser], user_id: current_user.id)
      # TODO CHECK WITH MODALS 
      if @flag.valid?
        if @flag.save
          render body: nil, status: 200
        else
          render_500
        end
      else
        render :new
      end
    else
      render_401
    end
  end
end
