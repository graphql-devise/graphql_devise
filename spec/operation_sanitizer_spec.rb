require 'rails_helper'

RSpec.describe GraphqlDevise::OperationSanitizer do
  describe '.call' do
    subject { described_class.call(default: default, custom: custom, only: only, skipped: skipped) }

    let(:op_class_1) { Class.new }
    let(:op_class_2) { Class.new }
    let(:op_class_3) { Class.new }

    context 'when the operations passed are mutations' do
      let(:custom)   { {} }
      let(:skipped)  { [] }
      let(:only)     { [] }
      let(:default)  { { operation_1: op_class_1, operation_2: op_class_2 } }

      context 'when no other option besides default is passed' do
        it { is_expected.to eq(default) }
      end

      context 'when there are custom operations' do
        let(:custom) { { operation_1:   op_class_3, bad_operation: GraphQL::Schema::Resolver } }

        it { is_expected.to eq(operation_1: op_class_3, operation_2: op_class_2) }
      end

      context 'when there are only operations' do
        let(:only) { [:operation_1] }

        it { is_expected.to eq(operation_1: op_class_1) }
      end

      context 'when there are skipped operations' do
        let(:skipped) { [:operation_2] }

        it { is_expected.to eq(operation_1: op_class_1) }
      end
    end
  end
end
