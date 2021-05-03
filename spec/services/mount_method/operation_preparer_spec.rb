# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GraphqlDevise::MountMethod::OperationPreparer do
  describe '#call' do
    subject(:prepared_operations) do
      described_class.new(
        model:                 model,
        selected_operations:   selected,
        preparer:              preparer,
        custom:                custom,
        additional_operations: additional
      ).call
    end

    let(:logout_class) { Class.new(GraphQL::Schema::Resolver) }
    let(:model)        { User }
    let(:preparer)     { double(:preparer, call: logout_class) }
    let(:custom)       { { login: double(:custom_login, graphql_name: nil) } }
    let(:additional)   { { user_additional: double(:user_additional) } }
    let(:selected) do
      {
        login:  { klass: double(:login_default) },
        logout: { klass: logout_class }
      }
    end

    it 'is expected to return all provided operation keys' do
      expect(prepared_operations.keys).to contain_exactly(
        :user_login,
        :user_logout,
        :user_additional
      )
    end
  end
end
