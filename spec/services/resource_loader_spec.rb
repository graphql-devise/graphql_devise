# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GraphqlDevise::ResourceLoader do
  describe '#call' do
    subject(:loader) { described_class.new(resource, options, routing).call(query, mutation) }

    let(:query)    { class_double(GraphQL::Schema::Object) }
    let(:mutation) { class_double(GraphQL::Schema::Object) }
    let(:routing)  { false }
    let(:mounted)  { false }
    let(:resource) { User }
    let(:options)  { { only: [:login], additional_queries: { public_user: Class.new(GraphQL::Schema::Resolver) } } }

    before do
      allow(GraphqlDevise).to receive(:add_mapping).with(:user, resource)
      allow(GraphqlDevise).to receive(:resource_mounted?).with(User).and_return(mounted)
      allow(GraphqlDevise).to receive(:mount_resource).with(User)
    end

    it 'loads operations into the provided types' do
      expect(query).to             receive(:field).with(:public_user, resolver: instance_of(Class), authenticate: false)
      expect(mutation).to          receive(:field).with(:user_login, mutation: instance_of(Class), authenticate: false)
      expect(GraphqlDevise).to     receive(:add_mapping).with(:user, resource)
      expect(GraphqlDevise).not_to receive(:mount_resource)

      returned = loader

      expect(returned).to be_a(Struct)
    end

    context 'when resource is not class' do
      let(:resource) { 'User' }

      it 'raises an error' do
        expect { loader }.to raise_error(
          GraphqlDevise::Error,
          'A class must be provided when mounting a model. String values are no longer supported.'
        )
      end
    end

    context 'when mutation is nil' do
      let(:mutation) { nil }

      it 'raises an error' do
        expect { loader }.to raise_error(
          GraphqlDevise::Error,
          'You need to provide a mutation type unless all mutations are skipped'
        )
      end
    end

    context 'when query is nil' do
      let(:query) { nil }

      before { allow(mutation).to receive(:field) }

      it 'raises an error' do
        expect { loader }.to raise_error(
          GraphqlDevise::Error,
          'You need to provide a query type unless all queries are skipped'
        )
      end
    end

    context 'when invoked from router' do
      let(:routing) { true }

      before do
        allow(query).to    receive(:field)
        allow(mutation).to receive(:field)
      end

      it 'adds mappings' do
        expect(GraphqlDevise).to receive(:add_mapping).with(:user, resource)
        expect(GraphqlDevise).to receive(:mount_resource).with(User)

        loader
      end

      context 'when resource was already mounted' do
        before { allow(GraphqlDevise).to receive(:resource_mounted?).with(User).and_return(true) }

        it 'skips schema loading' do
          expect(query).not_to         receive(:field)
          expect(mutation).not_to      receive(:field)
          expect(GraphqlDevise).not_to receive(:add_mapping).with(:user, resource)
          expect(GraphqlDevise).not_to receive(:mount_resource)
        end
      end
    end
  end
end
