class Comment < ApplicationRecord

  #Controlli sulle chiavi esterne
  belongs_to :previous, optional: true, class_name: "Comment"
  belongs_to :user
  belongs_to :event


  #Controlla che i seguenti campi non siano vuoti
  validates :content, :presence => true


  #Condizione per cui eseguire la validReply
  def previousNil?
    previous_id.nil?
  end


  #Controlla che il commento abbia una reply valida
  def validReply
    if Comment.where(:id => self.previous_id, :event_id => self.event_id).length <= 0
      errors.add(:previous_id, "Comment cannot be this reply")
    end
  end
  validate :validReply, :unless => :previousNil? 

end
