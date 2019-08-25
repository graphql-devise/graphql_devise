class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :lockable,
         :validatable,
         :confirmable

  include DeviseTokenAuth::Concerns::User

  def valid_for_authentication?
    auth_available && super
  end
end
