# frozen_string_literal: true

module GraphqlDevise
  module Model
    class WithEmailUpdater
      def initialize(resource, attributes)
        @attributes = attributes
        @resource   = resource
      end

      def call
        resource_attributes = @attributes.except(:schema_url, :confirmation_success_url)
        return @resource.update(resource_attributes) unless requires_reconfirmation?(resource_attributes)

        @resource.assign_attributes(resource_attributes)

        if @resource.email == email_in_database
          return @resource.save
        elsif required_reconfirm_attributes?
          return false unless @resource.valid?

          store_unconfirmed_email
          saved = @resource.save
          send_confirmation_instructions(saved)

          saved
        else
          raise(
            GraphqlDevise::Error,
            'Method `update_with_email` requires attributes `confirmation_success_url` and `schema_url` for email reconfirmation to work'
          )
        end
      end

      private

      def required_reconfirm_attributes?
        @attributes[:schema_url].present? &&
          (@attributes[:confirmation_success_url].present? || DeviseTokenAuth.default_confirm_success_url.present?)
      end

      def requires_reconfirmation?(resource_attributes)
        resource_attributes.key?(:email) &&
          @resource.devise_modules.include?(:confirmable) &&
          @resource.respond_to?(:unconfirmed_email=)
      end

      def store_unconfirmed_email
        @resource.unconfirmed_email  = @resource.email
        @resource.confirmation_token = nil
        @resource.email              = email_in_database
        @resource.send(:generate_confirmation_token)
      end

      def email_in_database
        if Devise.activerecord51?
          @resource.email_in_database
        else
          @resource.email_was
        end
      end

      def send_confirmation_instructions(saved)
        return unless saved

        @resource.send_confirmation_instructions(
          redirect_url:  @attributes[:confirmation_success_url] || DeviseTokenAuth.default_confirm_success_url,
          template_path: ['graphql_devise/mailer'],
          schema_url:    @attributes[:schema_url]
        )
      end
    end
  end
end
