class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable

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
      user.username = auth.info.email.split("@")[0] # FIXME there could be an user that already has this username
      # user.name = auth.info.name   # assuming the user model has a name
      # user.avatar = auth.info.image  # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # in order to use the open() method with urls
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
    avatar.variant(resize: "100x100!").processed
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

  # give api key only after user is verified
  validates_uniqueness_of  :secretkey , allow_blank: true
  before_save :add_secretkey

  def add_secretkey
    if self.verification
      unless !self.secretkey.nil?
        self.secretkey = SecureRandom.urlsafe_base64(30,false)
      end
    else
      self.secretkey = nil
    end
  end

  # TODO bisogna aggiungere un controllo sulla position che sia una stringa di coordinate valide, come fatto per gli eventi:
  # validates_format_of :position, with: /^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?),[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)$/, :multiline => true

  # dependent destroy for user
  has_many :child_chats1, :class_name => "Chat", :foreign_key => "user1_id", dependent: :destroy
  has_many :child_chats2, :class_name => "Chat", :foreign_key => "user2_id", dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :flags, dependent: :destroy
  has_many :child_follower, :class_name => "Follow", :foreign_key => "follower_id", dependent: :destroy
  has_many :child_followed, :class_name => "Follow", :foreign_key => "followed_id", dependent: :destroy
  has_many :follows_tags, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :participations, dependent: :destroy

end
