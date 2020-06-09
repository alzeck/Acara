class Participation < ApplicationRecord
  
  #Controlli sulle chiavi esterne
  belongs_to :event
  belongs_to :user


  #Controlli sulle chiavi interne
  validates_uniqueness_of :event_id, scope: :user_id


  #Controlla che il valore sia tra quelli accettati (e conseguentemente che non sia vuoto)
  validates :value, :inclusion => {:in => ["i", "p"]}
  
end
