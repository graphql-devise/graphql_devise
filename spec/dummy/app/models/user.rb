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

  validates :name, presence: true

  def valid_for_authentication?
    auth_available && super
  end

  def do_something
    'Nothing to see here!'
  end
end
