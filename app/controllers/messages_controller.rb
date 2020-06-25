class MessagesController < ApplicationController

  #POST su /chats/:chat_id/messages
  def create
    if user_signed_in?
      par = params[:message].permit(:content)
      @message = Message.new(content: par[:content], chat_id: params[:chat_id], user_id: current_user.id)

      if @message.valid?
        if @message.save
          redirect_to chat_path(id: params[:chat_id])
        else
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
