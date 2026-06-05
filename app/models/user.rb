class User < ApplicationRecord
  after_create :send_welcome_email
  before_create :set_default_name

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :sent_requests, class_name: "Friendship", foreign_key: :requester_id, dependent: :destroy
  has_many :received_requests, class_name: "Friendship", foreign_key: :receiver_id, dependent: :destroy

  has_many :friends, -> { where(friendships: { status: "accepted" }) },
            through: :sent_requests, source: :receiver

  has_many :friends_received, -> { where(friendships: { status: "accepted" }) },
            through: :received_requests, source: :requester

  private

  def set_default_name
    self.name ||= email.split("@").first
  end

  def send_welcome_email
    UserMailer.welcome_email(self.id).deliver_later
  end
end