class Message < ApplicationRecord
  
  #Controlli sulle chiavi esterne
  belongs_to :chat
  belongs_to :user


  #Controlla che i seguenti campi non siano vuoti
  validates :content, :presence => true


  #Controlla che la chat abbia lo user internamente
  def validChat
    c = Chat.where(:id => self.chat_id)[0]

    if c.nil? || ( c.user1_id != self.user_id && c.user2_id != self.user_id )
      errors.add(:user_id, "User is not allowed to send messages in this chat")
    end
  end
  validate :validChat

end
