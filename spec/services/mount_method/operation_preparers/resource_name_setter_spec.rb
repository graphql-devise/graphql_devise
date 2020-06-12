require 'spec_helper'

RSpec.describe GraphqlDevise::MountMethod::OperationPreparers::ResourceNameSetter do
  describe '#call' do
    subject(:prepared_operation) { described_class.new(mapping_name).call(operation) }

    let(:operation)    { double(:operation) }
    let(:mapping_name) { :user }

    it 'sets a gql name to the operation' do
      expect(prepared_operation.instance_variable_get(:@resource_name)).to eq(:user)
    end
  end
end
