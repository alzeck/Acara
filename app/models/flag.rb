class Flag < ApplicationRecord

  #un flag ha un solo utente
  belongs_to :user
  validates_associated :user


  #Controlla che i seguenti campi non siano vuoti
  validates :reason, :presence => true, :inclusion => {:in => ["Dangerous Activity & Self Injury", "Harassment & Trolling", "Nudity & Pornography", "Bullying", "Misleading Event/User", "Spam", "Other...", "Verification"]}
  validates :url, :presence => true


  # TODO controlla che url sia valido (magari che sia proprio o di profilo o di evento o di commento)
  # https://github.com/perfectline/validates_url

end
