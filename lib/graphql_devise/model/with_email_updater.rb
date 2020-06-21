module GraphqlDevise
  module Model
    class WithEmailUpdater
      def initialize(resource, attributes)
        @attributes = attributes
        @resource   = resource
      end

      def call
        resource_attributes = @attributes.except(:schema_url, :confirmation_success_url)

        if resource_attributes.key?(:email) && @resource.respond_to?(:unconfirmed_email=)
          unless @attributes[:schema_url].present? && (@attributes[:confirmation_success_url].present? || DeviseTokenAuth.default_confirm_success_url.present?)
            raise(
              GraphqlDevise::Error,
              'Method `update_with_email` requires attributes `confirmation_success_url` and `schema_url` for email reconfirmation to work'
            )
          end

          @resource.assign_attributes(resource_attributes)
          return false unless @resource.valid?

          @resource.unconfirmed_email  = @resource.email
          @resource.confirmation_token = nil
          @resource.email              = if Devise.activerecord51?
            @resource.email_in_database
          else
            @resource.email_was
          end
          @resource.send(:generate_confirmation_token)

          saved = @resource.save

          if saved
            @resource.send_confirmation_instructions(
              redirect_url:  @attributes[:confirmation_success_url] || DeviseTokenAuth.default_confirm_success_url,
              template_path: ['graphql_devise/mailer'],
              schema_url:    @attributes[:schema_url]
            )
          end

          saved
        else
          @resource.update(resource_attributes)
        end
      end
    end
  end
end
