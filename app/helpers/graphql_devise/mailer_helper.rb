module GraphqlDevise
  module MailerHelper
    def confirmation_query(resource_name)
      name = "#{resource_name.camelize(:lower)}ConfirmAccount"
      raw = <<-GRAPHQL
        query($token:String!,$redirect:String!){
          #{name}(confirmationToken:$token,redirectUrl:$redirect){
            email
          }
        }
      GRAPHQL
      raw.delete("\n").delete(' ')
    end
  end
end
