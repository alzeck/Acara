class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  devise :omniauthable, omniauth_providers: %i[facebook]

  # validate username
  validates :username, presence: true, uniqueness: { case_sensitive: false }

  #To allow users to login with username or email
  attr_writer :login

  def login
    @login || self.username || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  # Only allow letter, number, underscore and punctuation.
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true

  # Only allow passwords of 8 characters minumum with lower and upper case letters, numbers and punctuation.
  def password_complexity
    return if password.blank? || password =~ /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])/
    errors.add :password, "Complexity requirement not met. Please use: 1 uppercase, 1 lowercase, 1 digit and 1 special character"
  end

  validate :password_complexity

  # Prevent username to have someone else is email as username
  validate :validate_username

  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end

  # Oauth
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.username = auth.info.email.split("@")[0] + "_" + Time.now.strftime("%d%m%y%H%M%S") 
      # Adds _timestamp to prevent users with same username
      
      require "open-uri"
      # open the link
      downloaded_image = open(auth.info.image)

      # upload via ActiveStorage
      # be careful here! the type may be png or other type!
      user.avatar.attach(io: downloaded_image, filename: "avatar.jpg", content_type: downloaded_image.content_type)

      user.skip_confirmation!
    end
  end

  # User Profile image
  has_one_attached :avatar
  after_commit :add_default_avatar, on: %i[create update]

  def avatar_thumbnail
    begin 
      avatar.variant(resize: "100x100!").processed
    rescue
      ActiveStorage::Blob.create_and_upload!(
        io: File.open(
          Rails.root.join(
            "app", "assets", "images", "default_profile.jpg"
          )
        ),
        filename: "default_profile.jpg",
        content_type: "image/jpg",
      )
    end
  end

  validate :avatar_format
  def avatar_format
    if avatar.attached? && !avatar.content_type.in?(%w(image/jpeg image/png))
      errors.add(:avatar, "Image type is not supported try with jpeg or png")
    end
  end

  def add_default_avatar
    unless avatar.attached?
      avatar.attach(
        io: File.open(
          Rails.root.join(
            "app", "assets", "images", "default_profile.jpg"
          )
        ),
        filename: "default_profile.jpg",
        content_type: "image/jpg",
      )
    end
  end

  # followers and following
  def following
    Follow.where(follower: self).length
  end

  def followers
    Follow.where(followed: self).length
  end

  def isFollowing(user)
    !Follow.where(follower: self, followed: user).empty?
  end

  def followsTag?(tag)
    !FollowsTag.where(user: self, tag: tag).empty?
  end

  def verificationAsked?
    !Flag.where(user: self, reason: "Verification").empty?
  end

  # give api key only after user is verified
  validates_uniqueness_of :secretkey, allow_blank: true

  after_commit :add_secretkey, on: %i[create update]

  def add_secretkey
    if self.verification
      unless !self.secretkey.nil?
        self.secretkey = SecureRandom.urlsafe_base64(30, false)
        self.save
      end
    else
      unless self.secretkey.nil?
        self.secretkey = nil
        self.save
      end
    end
  end

  after_commit :force_confirmation_email, on: :create

  def force_confirmation_email
    self.send_confirmation_instructions
  end

  # Controlla che la position sia una stringa di coordinate valide, come fatto per gli eventi, o una stringa vuota se non ci sono:
  def validPosition
    if !position.match?(/^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?),[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)$/) && !position.match?(/^$/)
      errors.add(:position, "Position is not valid")
    end
  end

  validate :validPosition

  # Funzione chiamata da whenever per il resoconto settimanale
  def self.send_report_email_all
    for user in User.where(mailflag: true)
      ReportMailer.send_report_email(user).deliver
    end
  end

  # dependent destroy for user
  has_many :child_chats1, :class_name => "Chat", :foreign_key => "user1_id", dependent: :destroy
  has_many :child_chats2, :class_name => "Chat", :foreign_key => "user2_id", dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :flags, dependent: :destroy
  has_many :child_flags, :class_name => "Flag", :foreign_key => "flaggedUser_id", dependent: :destroy
  has_many :child_follower, :class_name => "Follow", :foreign_key => "follower_id", dependent: :destroy
  has_many :child_followed, :class_name => "Follow", :foreign_key => "followed_id", dependent: :destroy
  has_many :follows_tags, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :participations, dependent: :destroy

  # Overwrite json for api
  def as_json(options = {})
    super(({ only: %i[id username verification] }).merge(options))
  end

  def verificationIcon
    if self.admin?
      "admin-icon"
    elsif self.verification?
      "verified-icon"
    else
      ""
    end
  end
end
