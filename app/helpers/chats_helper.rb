module ChatsHelper
  def receiver(chat)
    if chat.user1 == current_user
      chat.user2
    else
      chat.user1
    end
  end

  def getAlignment(user)
    if user == current_user
      "ml-auto"
    else
      "mr-auto"
    end
  end

  def messageRead(msg)
    msg.user == current_user or msg.read?  
  end



end
