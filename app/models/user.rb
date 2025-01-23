class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :omniauthable

  def self.from_omniauth(auth)
    where(uid: auth.uid).first_or_create do |user|
      user.uid = auth.uid
      user.username = auth.info.name
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def self.guest(session_id)
    new(id: session_id, username: 'guest user')
  end
end
