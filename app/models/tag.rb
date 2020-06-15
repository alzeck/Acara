class Tag < ApplicationRecord

  #Controlli sulle chiavi esterne
  has_many :has_tags, dependent: :destroy
  has_many :follows_tags, dependent: :destroy

  #Controlla che i seguenti campi non siano vuoti
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  # Only allow letter, number, underscore and punctuation.
  validates_format_of :name, with: /^#[a-z0-9_]*$/, :multiline => true

end
