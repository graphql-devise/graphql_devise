# frozen_string_literal: true

module GraphqlDevise
  module MailerHelper
    def confirmation_query(resource_name:, token:, redirect_url:)
      name = "#{GraphqlDevise.to_mapping_name(resource_name).camelize(:lower)}ConfirmAccount"
      raw = <<-GRAPHQL
        query($token:String!,$redirectUrl:String!){
          #{name}(confirmationToken:$token,redirectUrl:$redirectUrl){
            email
          }
        }
      GRAPHQL

      {
        query:     raw.delete("\n").delete(' ').html_safe,
        variables: { token: token, redirectUrl: redirect_url }
      }
    end

    def password_reset_query(token:, redirect_url:, resource_name:)
      name = "#{GraphqlDevise.to_mapping_name(resource_name).camelize(:lower)}CheckPasswordToken"
      raw = <<-GRAPHQL
        query($token:String!,$redirectUrl:String!){
          #{name}(resetPasswordToken:$token,redirectUrl:$redirectUrl){
            email
          }
        }
      GRAPHQL

      {
        query:     raw.delete("\n").delete(' ').html_safe,
        variables: { token: token, redirectUrl: redirect_url }
      }
    end
  end
end
