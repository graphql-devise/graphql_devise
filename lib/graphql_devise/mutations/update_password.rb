# frozen_string_literal: true

module GraphqlDevise
  module Mutations
    class UpdatePassword < Base
      argument :password,              String, required: true
      argument :password_confirmation, String, required: true
      argument :current_password,      String, required: false

      def resolve(current_password: nil, **attrs)
        if current_resource.blank?
          raise_user_error(I18n.t('graphql_devise.not_authenticated'))
        elsif current_resource.provider != 'email'
          raise_user_error(
            I18n.t('graphql_devise.passwords.password_not_required', provider: current_resource.provider.humanize)
          )
        end

        if update_resource_password(current_password, attrs)
          current_resource.allow_password_change = false if recoverable_enabled?
          current_resource.save!

          yield current_resource if block_given?

          { authenticatable: current_resource }
        else
          raise_user_error_list(
            I18n.t('graphql_devise.passwords.update_password_error'),
            errors: current_resource.errors.full_messages
          )
        end
      end

      private

      def update_resource_password(current_password, attrs)
        allow_password_change = recoverable_enabled? && current_resource.allow_password_change == true
        if DeviseTokenAuth.check_current_password_before_update == false || allow_password_change
          current_resource.public_send(:update, attrs)
        else
          current_resource.public_send(:update_with_password, attrs.merge(current_password: current_password))
        end
      end
    end
  end
end
