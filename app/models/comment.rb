class Comment < ApplicationRecord

  #Controlli sulle chiavi esterne
  belongs_to :previous, optional: true, class_name: "Comment"
  belongs_to :user
  belongs_to :event
  has_many :child_comments, :class_name => "Comment", :foreign_key => "previous_id", dependent: :destroy

  
  #Controlla che i seguenti campi non siano vuoti
  validates :content, :presence => true


  #Condizione per cui eseguire la validReply
  def previousNil?
    previous_id.nil?
  end


  #Controlla che il commento abbia una reply valida
  def validReply
    if Comment.where(:id => self.previous_id, :event_id => self.event_id).length <= 0 || !Comment.find(self.previous_id).previous_id.nil?
      errors.add(:previous_id, "Comment cannot be this reply")
    end
  end
  validate :validReply, :unless => :previousNil?

end
