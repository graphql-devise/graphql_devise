# frozen_string_literal: true

module GraphqlDevise
  module AdditionalModelMethods
    extend ActiveSupport::Concern

    class_methods do
      def reconfirmable
        column_attributes = try(:column_names) || []
        fields_attributes = try(:fields)&.keys || []
        has_unconfirmed_email_attr = column_attributes.include?('unconfirmed_email') || fields_attributes.include?('unconfirmed_email')
        devise_modules.include?(:confirmable) && has_unconfirmed_email_attr
      end
    end

    def update_with_email(attributes = {})
      GraphqlDevise::Model::WithEmailUpdater.new(self, attributes).call
    end
  end
end
