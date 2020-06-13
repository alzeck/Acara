class Event < ApplicationRecord

  #Controlli sulle chiavi esterne
  belongs_to :user


  #Controlla che i seguenti campi non siano vuoti
  validates :where, presence: true
  validates :cords, presence: true
  validates :start, presence: true
  validates :end, presence: true
  validates :title, presence: true
  validates :description, presence: true


  #Immagine di Copertina
  has_one_attached :cover


  #Controlla che le coordinate siano effettivamente valide
  validates_format_of :cords, with: /^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?),\s*[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)$/, :multiline => true


  #Controlla che l'evento non finisca prima di cominciare
  def startBeforeEnd
    if start.to_datetime > self.end.to_datetime
      errors.add(:start, "Event ends before it starts")
    end
  end
  validate :startBeforeEnd


  # TODO Controlla che la stringa di where corrisponda alle coordinate date


  #variabile indicante quanti utenti partecipano al dato evento
  def going
    Participation.where(event: self, value: "p").length
  end


  #variabile indicante quanti utenti sono interessati al dato evento
  def interested 
    Participation.where(event: self, value: "i").length
  end


  #variabile indicante i nomi dei tag del dato evento
  def tags 
    ht = HasTag.where(event: self)

    arr = []
    for elem in ht
      arr << Tag.find(elem.tag_id).name
    end

    return arr
  end


  #variabile indicante i commenti del dato evento (in ordine dentro una mappa)
  def comments
    commNoReply = Comment.where(event: self, previous_id: nil).sort_by(&:created_at)

    comments = []
    for elem in commNoReply
      comments << { comment: elem, replies: Comment.where(event: self, previous_id: elem.id).sort_by(&:created_at) }
    end

    return comments
  end

  def coords
    { lat: self.cords.split(',')[0].strip, lng: self.cords.split(',')[1].strip }
  end

end
