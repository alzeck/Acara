class Chat < ApplicationRecord

  #Una chat ha un solo utente 1
  belongs_to :user1
  validates_associated :user1


  #Una chat ha un solo utente 2
  belongs_to :user2
  validates_associated :user2


  #Controllo che i due utenti della chat non siano lo stesso
  #(nel caso specifico che il primo abbia id minore strettamente per semplificarne gestione)
  def differentUsers
    if user1 >= user2
      errors.add(:id, 'Order of the users is invalid')
    end
  end
  validate :differentUsers


  # TODO va messa come chiave la coppia user1 e user2

end
