# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GraphqlDevise::SchemaPlugin do
  describe '#call' do
    subject(:plugin) { described_class.new(query: query, mutation: mutation, resource_loaders: loaders) }

    let(:query)    { instance_double(GraphQL::Schema::Object) }
    let(:mutation) { instance_double(GraphQL::Schema::Object) }

    context 'when loaders are not provided' do
      let(:loaders) { [] }

      it 'does not fail' do
        expect { plugin }.not_to raise_error
      end
    end

    context 'when a loaders is not an instance of loader' do
      let(:loaders) { ['not a loader instance'] }

      it 'raises an error' do
        expect { plugin }.to raise_error(GraphqlDevise::Error, 'Invalid resource loader instance')
      end
    end
  end
end
