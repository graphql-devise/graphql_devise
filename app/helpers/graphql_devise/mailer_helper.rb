module GraphqlDevise
  module MailerHelper
    extend ActiveSupport::Concern

    protected

    def confirmation_query(token:, config:, redirect_url:)
      raw = <<-GRAPHQL
        confirmAccount($token:ID!,$clientConfig:String,redirect:String!){
          userConfirmAccount(token:$token,clientConfig:$clientConfig,redirect:$redirect
            ){
            success,errors
          }
        }&variables={token:"#{token}",clientConfig:"#{config}",redirect:"#{redirect_url}"}
      GRAPHQL
      ERB::Util.url_encode(raw.gsub("\n", '').gsub(' ', ''))
    end
  end
end
