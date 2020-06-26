class ChatChannel < ApplicationCable::Channel
    def subscribed
      chat = Chat.find params[:chat]
      stream_for chat
    end

    def receive(data)
      if Chat.exists?(data["chat_id"])
        chat = Chat.find data["chat_id"]
        if chat.user1_id == current_user or chat.user2_id == current_user
          chat.updateMessagesRead(current_user)
        end
      end
      
    end
  end
  