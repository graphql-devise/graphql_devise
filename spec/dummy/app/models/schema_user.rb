# frozen_string_literal: true

class SchemaUser < ApplicationRecord
  devise :database_authenticatable,
         :recoverable,
         :trackable,
         :validatable,
         :confirmable

  include GraphqlDevise::Concerns::Model

  validates :name, presence: true
end
