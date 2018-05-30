class User < ActiveRecord::Base
  attr_accessor :password, :password_confirmation, :image
  before_create :create_confirmation_token

  validates :email, :password, presence: true
  validates :email, uniqueness: true
  validates :password, length: { minimum: 7, message: 'Password must be at least 7 characters' }
  # validates :bio, maximum: 300, message: 'over character limit'

  has_many :reviews
  has_many :venues
  has_many :user_venues
  has_many :favorites, through: :user_venues, source: :venue
  has_many :user_events
  has_many :events, through: :user_events
  has_many :reports

  has_one :image, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :image


  def authenticated?(password)
    self.email_confirmed? && self.password_hash == self.hash_password(password)
  end


  def self.find_for_authentication(email)
    User.find_by(email: email)
  end


  def generate_auth_token
    token = SecureRandom.hex
    self.update_columns(auth_token: token, token_created_at: Time.zone.now)
    token
  end


  def invalidate_auth_token
    self.update_columns(auth_token: nil, token_created_at: nil)
  end


  def encrypt_password(password, confirmation)
    if password && confirmation && password == confirmation
      self.password_hash = self.hash_password(password)
    end
  end


  def hash_password(pw)
    to_encrypt = pw + ENV['SALT']
    Digest::SHA1.hexdigest(to_encrypt)
  end


  def confirm_email
    self.email_confirmed = true
    self.confirmation_token = nil
    save!(validate: false)
  end

  def confirmation_link
    self.confirmation_token ? "localhost:3000/confirm_email/#{self.confirmation_token}" : nil
  end

  # private

  def create_confirmation_token
    if !self.confirmation_token?
      self.confirmation_token = SecureRandom.urlsafe_base64.to_s
    end
  end

  def email_confirmed?
    !!self.email_confirmed
  end

  def num_of_reviews
    self.reviews.length
  end

  def avg_review_rating
    avg = 0
    if self.num_of_reviews > 0
      avg = self.reviews.pluck(:rating).reduce(:+) / self.reviews.length
    end
    avg
  end

  def num_venues_added
    self.venues.length
  end

  def image
    Image.find_by(
      imageable_id: self.id,
      imageable_type: 'User'
    )
  end

  def profile_image
    self.image ? self.image.photo.url(:small) : nil
  end


  def custom_json
    { id: self.id,
      name: self.name,
      bio: self.bio,
      reviews: self.num_of_reviews,
      venues_added: self.num_venues_added,
      profile_image: self.profile_image,
      num_venues_added: self.num_venues_added,
      num_of_favorites: self.favorites.length,
      num_of_ratings: self.num_of_reviews,
      avg_rating: self.avg_review_rating
    }
  end
end
