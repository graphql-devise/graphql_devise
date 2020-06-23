# frozen_string_literal: true

GraphqlDevise::Engine.routes.draw do
  # Required as Devise forces routes to reload on eager_load
  unless GraphqlDevise.schema_loaded?
    if GraphqlDevise::Types::QueryType.fields.blank?
      GraphqlDevise::Types::QueryType.field(:dummy, resolver: GraphqlDevise::Resolvers::Dummy)
    end

    if GraphqlDevise::Types::MutationType.fields.present?
      GraphqlDevise::Schema.mutation(GraphqlDevise::Types::MutationType)
    end

    GraphqlDevise::Schema.query(GraphqlDevise::Types::QueryType)

    GraphqlDevise.load_schema

    Devise.mailer.helper(GraphqlDevise::MailerHelper)
  end
end
