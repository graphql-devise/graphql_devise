# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GraphqlDevise::MountMethod::OperationPreparers::ResourceKlassSetter do
  describe '#call' do
    subject(:prepared_operation) { described_class.new(model).call(operation) }

    let(:operation) { double(:operation) }
    let(:model) { User }

    it 'sets a gql name to the operation' do
      expect(prepared_operation.instance_variable_get(:@resource_klass)).to eq(model)
    end
  end
end
