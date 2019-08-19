module GraphqlDevise
  module Mutations
    class Login < GraphQL::Schema::Mutation
      argument :email,    String, required: true
      argument :password, String, required: true

      field :authenticable, GraphqlDevise::Types::AuthenticableType, null: true

      def resolve(email:, password:)
        resource = context[:resource_class].find_by(email: email)

        if resource && (!resource.respond_to?(:active_for_authentication?) || resource.active_for_authentication?)
          valid_password = resource.valid_password?(password)
          if (resource.respond_to?(:valid_for_authentication?) && !resource.valid_for_authentication? { valid_password }) || !valid_password
            return {}
          end

          auth_headers = resource.create_new_auth_token
          context[:response].headers.merge!(auth_headers)

          { authenticable: resource }
        elsif resource && !(!resource.respond_to?(:active_for_authentication?) || resource.active_for_authentication?)
          if resource.respond_to?(:locked_at) && resource.locked_at
            return {}
          else
            return {}
          end
        else
          return {}
        end
      end
    end
  end
end
