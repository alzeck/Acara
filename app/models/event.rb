class Event < ApplicationRecord

  #Una chat ha un solo utente
  belongs_to :user
  #validates_associated :user


  #Controlla che i seguenti campi non siano vuoti
  validates :where, presence: true
  validates :cords, presence: true
  validates :start, presence: true
  validates :end, presence: true
  validates :title, presence: true
  validates :description, presence: true

  validates_format_of :cords, with: /^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?),\s*[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)$/, :multiline => true
    
  #Controlla che l'evento non finisca prima di cominciare
  def startBeforeEnd
    if start.to_datetime > self.end.to_datetime
      errors.add(:start, 'Event ends before it starts')
    end
  end
  validate :startBeforeEnd


  #controlla che le coordinate siano stringhe valide
  # def areCoordinates
  #   cords.match?(/^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?),\s*[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)$/)
  # end
  # validate :areCoordinates


  # TODO controlla che la stringa di where corrisponda alle coordinate date

  # TODO mettere nel db che modified sia default false

end
