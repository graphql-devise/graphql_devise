# frozen_string_literal: true

module Users
  class Customer < ApplicationRecord
    devise :database_authenticatable, :validatable

    include GraphqlDevise::Concerns::Model

    validates :name, presence: true
  end
end
