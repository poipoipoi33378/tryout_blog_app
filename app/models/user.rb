class User < ApplicationRecord
  has_many :blogs,dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  validates :name,presence: true,length: {maximum: 50}

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    unless user
      user = User.create(
                     name: data['name'],
                     uid: data['uid'],
                     token: access_token.credentials.token,
                     email: data['email'],
                     password: Devise.friendly_token[0,20]
        )
    end
    user
  end
end
