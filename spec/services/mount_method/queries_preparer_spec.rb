require 'rails_helper'

RSpec.describe GraphqlDevise::MountMethod::QueriesPreparer do
  describe '.call' do
    subject do
      described_class.call(
        resource:             resource,
        queries:              queries,
        authenticatable_type: auth_type
      )
    end

    let(:resource)  { 'User' }
    let(:class1)    { Class.new(GraphQL::Schema::Resolver) }
    let(:class2)    { GraphQL::Schema::Resolver }
    let(:auth_type) { GraphqlDevise::Types::AuthenticatableType }
    let(:queries)   { { query1: class1, query2: class2 } }

    context 'when queries is *NOT* empty' do
      it 'assign gql attibutes to queries and changes keys using resource map' do
        result = subject

        expect(result.keys).to contain_exactly(:user_query1, :user_query2)
        expect(result.values.map(&:graphql_name)).to contain_exactly(
          'UserQuery1', 'UserQuery2'
        )
        expect(result.values.map(&:type).uniq.first).to eq(auth_type)
      end
    end

    context 'when queries is empty' do
      let(:queries) { {} }

      it { is_expected.to be_empty }
    end
  end
end
