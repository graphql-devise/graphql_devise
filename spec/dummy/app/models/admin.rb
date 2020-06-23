# frozen_string_literal: true

class Admin < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :validatable,
         :confirmable

  include GraphqlDevise::Concerns::Model
end
