require 'rails_helper'

RSpec.describe GraphqlDevise::MountMethod::MutationsPreparer do
  describe '.call' do
    subject do
      described_class.call(
        resource:             resource,
        mutations:            mutations,
        authenticatable_type: auth_type
      )
    end

    let(:resource)  { 'User' }
    let(:class1)    { Class.new(GraphQL::Schema::Mutation) }
    let(:class2)    { GraphQL::Schema::Mutation }
    let(:auth_type) { GraphqlDevise::Types::AuthenticatableType }
    let(:mutations) { { mutation1: class1, mutation2: class2 } }

    context 'when mutations is *NOT* empty' do
      it 'assign gql attibutes to mutations and changes keys using resource map' do
        result = subject

        expect(result.keys).to contain_exactly(:user_mutation1, :user_mutation2)
        expect(result.values.map(&:graphql_name)).to contain_exactly(
          'UserMutation1', 'UserMutation2'
        )
        expect(result.values.map(&:own_fields).flat_map(&:values).map(&:type).uniq.first)
          .to eq(auth_type)
      end
    end

    context 'when mutations is empty' do
      let(:mutations) { {} }

      it { is_expected.to be_empty }
    end
  end
end
