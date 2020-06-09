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


  #Immagini di Copertina e Galleria 
  has_one_attached :cover
  has_many_attached :gallery


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


end
