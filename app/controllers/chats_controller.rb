class ChatsController < ApplicationController

  #GET su /chats
  def index
    if user_signed_in?
      @chats = Chat.where("chats.user1_id = #{current_user.id} OR chats.user2_id = #{current_user.id}")
    else
      render_401
    end
  end


  #GET su /chats/:id
  def show
    if user_signed_in?
      if Chat.exists?(params[:id])
        @chat = Chat.find(params[:id])

        if @chat.user1_id == current_user.id || @chat.user2_id == current_user.id
          @messages = Message.where(chat_id: params[:id]).sort_by(&:created_at)
        else
          render_403
        end

      else
        render_404
      end
    else
      render_401
    end
  end
  

  #POST su /chats
  def create
    if user_signed_in?
      par = params[:chat].permit(:user_id)
      primo_id = par[:where] > current_user.id ? par[:where] : current_user.id
      secondo_id = par[:where] < current_user.id ? par[:where] : current_user.id
      @chat = Chat.new(user1_id: primo_id, user2_id: secondo_id)

      if @chat.valid?
        if @chat.save
          redirect_to chats_path
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
