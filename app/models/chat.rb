class Chat < ApplicationRecord

  #Controlli sulle chiavi esterne
  belongs_to :user1, class_name: "User"
  belongs_to :user2, class_name: "User"
  has_many :messages, dependent: :destroy

  #Controlli sulle chiavi interne
  validates_uniqueness_of :user1_id, scope: :user2_id


  #Controlla che la chat venga creata ponendo l'id strettamente minore come primo
  #(ciò previene la presenza di chat ridondanti o con se stesso)
  def usersOrder
    if user1_id >= user2_id
      errors.add(:user1_id, "Order of the users is invalid")
    end
  end
  validate :usersOrder

end
