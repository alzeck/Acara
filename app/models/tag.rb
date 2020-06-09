class Tag < ApplicationRecord

  #Controlla che i seguenti campi non siano vuoti
  validates :name, :presence => true

end
