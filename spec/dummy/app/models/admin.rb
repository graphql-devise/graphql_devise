class Admin < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :validatable,
         :confirmable

  include DeviseTokenAuth::Concerns::User
end
