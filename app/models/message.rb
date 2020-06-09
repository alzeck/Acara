class Message < ApplicationRecord
  
  #Un messaggio ha una sola chat
  belongs_to :chat
  validates_associated :chat


  #Un messaggio ha un solo utente
  belongs_to :user
  validates_associated :user


  #Controlla che i seguenti campi non siano vuoti
  validates :content, :presence => true
  validates :read, :presence => true

end
