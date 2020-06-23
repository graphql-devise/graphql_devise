# frozen_string_literal: true

class Guest < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :validatable

  include GraphqlDevise::Concerns::Model
end
