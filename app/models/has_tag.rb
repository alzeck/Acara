class HasTag < ApplicationRecord
  
  #Un HasTag ha un solo evento
  belongs_to :event
  validates_associated :event


  #Un HasTag ha un solo tag
  belongs_to :tag
  validates_associated :tag

end
