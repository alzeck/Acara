class Comment < ApplicationRecord

  #un commento può avere solo un precedente commento
  belongs_to :previous, optional: true
  #validates_associated :previous


  #Un commento ha un solo utente
  belongs_to :user
  #validates_associated :user


  #Un commento ha un solo evento
  belongs_to :event
  #validates_associated :event


  #Controlla che i seguenti campi non siano vuoti
  validates :content, :presence => true


  # FIXME
  #Controlla che il commento non sia reply di se stesso
  def notSelfReply
    if (! previous_id.nil?) && (previous_id == id)
      errors.add(:id, 'Comment is replying to itself')
    end
  end
  validate :notSelfReply

end
