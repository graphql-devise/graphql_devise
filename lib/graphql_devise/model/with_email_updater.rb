# frozen_string_literal: true

module GraphqlDevise
  module Model
    class WithEmailUpdater
      def initialize(resource, attributes)
        @attributes = attributes.with_indifferent_access
        @resource   = resource
      end

      def call
        resource_attributes = @attributes.except(:confirmation_url)
        return @resource.update(resource_attributes) unless requires_reconfirmation?(resource_attributes)

        @resource.assign_attributes(resource_attributes)

        if @resource.email == email_in_database
          @resource.save
        elsif required_reconfirm_attributes?
          return false unless @resource.valid?

          store_unconfirmed_email
          saved = @resource.save
          send_confirmation_instructions(saved)

          saved
        else
          raise(
            ::GraphqlDevise::Error,
            'Method `update_with_email` requires attribute `confirmation_url` for email reconfirmation to work'
          )
        end
      end

      private

      def required_reconfirm_attributes?
        [@attributes[:confirmation_url], DeviseTokenAuth.default_confirm_success_url].any?(&:present?)
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
        @resource.email_in_database
      end

      def confirmation_method_params
        { redirect_url: @attributes[:confirmation_url] || DeviseTokenAuth.default_confirm_success_url }
      end

      def send_confirmation_instructions(saved)
        return unless saved

        @resource.send_confirmation_instructions(
          confirmation_method_params.merge(template_path: ['graphql_devise/mailer'])
        )
      end
    end
  end
end
