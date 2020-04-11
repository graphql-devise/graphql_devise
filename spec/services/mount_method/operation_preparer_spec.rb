require 'spec_helper'

RSpec.describe GraphqlDevise::MountMethod::OperationPreparer do
  describe '#call' do
    subject(:prepared_operations) do
      described_class.new(
        resource:              resource,
        selected_operations:   selected,
        preparer:              preparer,
        custom:                custom,
        additional_operations: additional
      ).call
    end

    let(:logout_class) { Class.new(GraphQL::Schema::Resolver) }
    let(:resource)     { 'User' }
    let(:selected)     { { login: double(:login_default), logout: logout_class } }
    let(:preparer)     { double(:preparer, call: logout_class) }
    let(:custom)       { { login: double(:custom_login, graphql_name: nil) } }
    let(:additional)   { { user_additional: double(:user_additional) } }

    it 'is expected to return all provided operation keys' do
      expect(prepared_operations.keys).to contain_exactly(
        :user_login,
        :user_logout,
        :user_additional
      )
    end
  end
end
