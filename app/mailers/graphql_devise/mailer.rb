module GraphqlDevise
  class Mailer < ActionMailer::Base
    default from: 'notifications@example.com'

    def confirmation_instructions(resource, token, redirect_url)
      @token = token
      @resource = resource
      @email = resource.email
      @redirect_url = redirect_url
      mail(to: @email, subject: 'Welcome to My Awesome Site')
    end
  end
end
