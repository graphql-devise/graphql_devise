# frozen_string_literal: true

module Types
  class CustomAdminType < GraphQL::Schema::Object
    field :email,        String, null: false
    field :custom_field, String, null: false

    def custom_field
      "email: #{object.email}"
    end
  end
end
