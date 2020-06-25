class FlagsController < ApplicationController

  #GET su /flags/new
  #Si basa sui parametri passati in get:
  # GET /flags/new?type=event&id=EVENT_ID
  # GET /flags/new?type=user&id=USER_ID
  # GET /flags/new?type=comment&id=COMMENT_ID
  def new
    if !user_signed_in?
      render_401

    elsif params.has_key?(:type) && params.has_key?(:id)
      tipo = params[:type]
      id = params[:id]

      if tipo == "event"
        @flaggedEvent = id
        @flaggedComment = nil
        @flaggedUser = nil
        
      elsif tipo == "user"
        @flaggedEvent = nil
        @flaggedComment = nil
        @flaggedUser = id

      elsif tipo == "comment"
        @flaggedEvent = nil
        @flaggedComment = id
        @flaggedUser = nil
        
      else
        render_400
      end

    else
      render_400
    end
  end

  #POST su /flags
  def create
    if user_signed_in?
      par = params[:flag].permit(:reason, :description, :flaggedEvent, :flaggedComment, :flaggedUser)
      flag = Flag.new(reason: par[:reason], description: par[:description], flaggedEvent_id: par[:flaggedEvent], flaggedComment_id: par[:flaggedComment], flaggedUser_id: par[:flaggedUser], user_id: current_user.id)

      if flag.valid?
        if !flag.save
          render_500
        end
      else
        render_400
      end
    else
      render_401
    end
  end

end
