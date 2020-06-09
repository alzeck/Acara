class HasTag < ApplicationRecord
  
  #Controlli sulle chiavi esterne
  belongs_to :event
  belongs_to :tag


  #Controlli sulle chiavi interne
  validates_uniqueness_of :event_id, scope: :tag_id

end
