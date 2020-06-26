class ChatChannel < ApplicationCable::Channel
    def subscribed
      chat = Chat.find params[:chat]
      stream_for chat
    end
  end
  