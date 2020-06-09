class Follow < ApplicationRecord

  #Controlli sulle chiavi esterne
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"


  #Controlli sulle chiavi interne
  validates_uniqueness_of :follower_id, scope: :followed_id


  #Controlla che il follow sia valido
  def validFollow
    if follower_id == followed_id
      errors.add(:followed_id, 'User is trying to follow itself')
    end
  end
  validate :validFollow

end
