class Tag < ApplicationRecord

  #Controlla che i seguenti campi non siano vuoti
  validates :name, :presence => true


  #Controlli sulle chiavi interne
  validates_uniqueness_of :name

end
