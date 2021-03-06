class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:twitter]
  has_many :tweets

   def self.find_for_oauth(auth)
      user = User.where(uid: auth.uid, provider: auth.provider).first

      if user
        user.update(token: auth.credentials.token, secret: auth.credentials.secret)
      else
        user = User.create(
          uid:      auth.uid,
          provider: auth.provider,
          email:    User.dummy_email(auth),
          password: Devise.friendly_token[0, 20],
          image: auth.info.image,
          name: auth.info.name,
          nickname: auth.info.nickname,
          token: auth.credentials.token,
          secret: auth.credentials.secret
          )
      end

      user
     end

     private

     def self.dummy_email(auth)
      "#{auth.uid}-#{auth.provider}@example.com"
     end

   end
