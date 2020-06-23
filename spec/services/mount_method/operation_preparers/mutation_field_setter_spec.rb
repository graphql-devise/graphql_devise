# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GraphqlDevise::MountMethod::OperationPreparers::MutationFieldSetter do
  describe '#call' do
    subject(:prepared_operation) { described_class.new(field_type).call(operation, authenticatable: authenticatable) }

    let(:operation)  { double(:operation) }
    let(:field_type) { double(:type) }

    context 'when resource is authtenticable' do
      let(:authenticatable) { true }

      it 'sets a field for the mutation' do
        expect(operation).to receive(:field).with(:authenticatable, field_type, null: false)

        prepared_operation
      end
    end

    context 'when resource is *NOT* authtenticable' do
      let(:authenticatable) { false }

      it 'does *NOT* set a field for the mutation' do
        expect(operation).not_to receive(:field)

        prepared_operation
      end
    end
  end
end
