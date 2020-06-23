# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GraphqlDevise::MountMethod::OperationPreparers::GqlNameSetter do
  describe '#call' do
    subject(:prepared_operation) { described_class.new(mapping_name).call(operation) }

    let(:operation)    { double(:operation) }
    let(:mapping_name) { 'user_login' }

    it 'sets a gql name to the operation' do
      expect(operation).to receive(:graphql_name).with('UserLogin')

      prepared_operation
    end
  end
end
