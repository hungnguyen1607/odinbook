class User < ApplicationRecord
  after_create :send_welcome_email
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :sent_requests, class_name: "Friendship", foreign_key: :requester_id, dependent: :destroy
  has_many :received_requests, class_name: "Friendship", foreign_key: :receiver_id, dependent: :destroy


  has_many :friends, -> { where(friendships: { status: "accepted" }) },
            through: :sent_requests, source: :receiver
  
  after_create :send_welcome_email

  private

  def send_welcome_email
    UserMailer.welcome_email(self.id).deliver_later
  end
end
