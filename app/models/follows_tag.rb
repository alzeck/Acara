class FollowsTag < ApplicationRecord
  
  #Un follow ha un solo utente
  belongs_to :user
  validates_associated :user


  #Un follow ha un solo tag
  belongs_to :tag
  validates_associated :tag
  
end
