class Participation < ApplicationRecord
  
  #Una partecipazione ha un solo evento
  belongs_to :event
  validates_associated :event


  #Un messaggio ha un solo utente
  belongs_to :user
  validates_associated :user


  #controlla che il valore della partecipazione sia valido e non vuoto
  validates :rating, :inclusion => {:in => ["i", "p"]}
  
end
