# frozen_string_literal: true

module Types
  class CustomAdminType < BaseObject
    field :email,        String, null: false
    field :custom_field, String, null: false

    def custom_field
      "email: #{object.email}"
    end
  end
end
