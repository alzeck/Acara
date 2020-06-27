class MessagesController < ApplicationController

  #POST su /chats/:chat_id/messages
  def create
    if user_signed_in? && Chat.exists?(params[:chat_id])
      par = params[:message].permit(:content)
      @chat = Chat.find(params[:chat_id])
      @message = Message.new(content: par[:content], chat_id: params[:chat_id], user_id: current_user.id)

      if @message.valid?
        if @message.save
          ChatChannel.broadcast_to @chat, @message
          @chat.touch # Update timestamp update_at for order 
          render body: nil, status: 200
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
