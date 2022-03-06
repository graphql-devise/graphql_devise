# frozen_string_literal: true

module Users
  class Customer < ApplicationRecord
    devise :database_authenticatable, :validatable

    include GraphqlDevise::Authenticatable

    validates :name, presence: true
  end
end
