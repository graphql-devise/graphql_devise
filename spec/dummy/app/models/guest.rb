class Guest < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :validatable,
         :confirmable

  include GraphqlDevise::Concerns::Model
end
