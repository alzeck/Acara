class Flag < ApplicationRecord

  #Controlli sulle chiavi esterne
  belongs_to :user


  #Controlla che i seguenti campi non siano vuoti
  validates :url, :presence => true


  #Controlla che la ragione sia tra quelle accettate (e conseguentemente che non sia vuota)
  validates :reason, :inclusion => {:in => ["Dangerous Activity & Self Injury", "Harassment & Trolling", "Nudity & Pornography", "Bullying", "Misleading Event/User", "Spam", "Other...", "Verification"]}


  # TODO controlla che url sia valido (magari che sia proprio o di profilo o di evento o di commento)
  # https://github.com/perfectline/validates_url

end
