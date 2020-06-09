class Follow < ApplicationRecord

  #Un follow ha un solo follower
  belongs_to :follower
  validates_associated :follower


  #Un follow ha un solo followed
  belongs_to :followed
  validates_associated :followed


  #Controlla che il follow non sia di se stesso
  def notSelfFollow
    if follower_id == followed_id
      errors.add(:follower, 'User is trying to follow itself')
    end
  end
  validate :notSelfFollow

end
