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
      @chats = Chat.where("chats.user1_id = #{current_user.id} OR chats.user2_id = #{current_user.id}")
      if Chat.exists?(params[:id])
        @chat = Chat.find(params[:id])
        @message = Message.new chat: @chat
        if @chat.user1_id == current_user.id || @chat.user2_id == current_user.id
          @chat.updateMessagesRead(current_user) # Update all the received messages as read 
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
      par = params[:chat].present? ? params[:chat].permit(:user_id)[:user_id] : nil
      # TODO check if this control is needed elsewhere
      if par.present?
        # verify if the needed param has been given ( avoid to)
        user = par.to_i 
        primo_id = user < current_user.id ? user : current_user.id
        secondo_id = user > current_user.id ? user : current_user.id

        # Check if the chat already exists ( case user tries to access from profile )
        @chat = Chat.where(user1_id: primo_id, user2_id: secondo_id)[0]
        if @chat.present?
        # if the chat exists redirect to
        redirect_to chat_path(@chat)
      else
        # else try to create it
        @chat = Chat.new(user1_id: primo_id, user2_id: secondo_id)
        @chat.save!
        if @chat.valid?
          if @chat.save
            redirect_to chat_path(@chat)
          else
            render_500
          end
        else
          render_400
        end
        end
      else
        render_404
      end
    else
      render_401
    end
  end
end
