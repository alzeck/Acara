class FollowsTag < ApplicationRecord
  
  #Controlli sulle chiavi esterne
  belongs_to :user
  belongs_to :tag


  #Controlli sulle chiavi interne
  validates_uniqueness_of :user_id, scope: :tag_id
  
end
