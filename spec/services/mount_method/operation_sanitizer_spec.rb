# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GraphqlDevise::MountMethod::OperationSanitizer do
  describe '.call' do
    subject(:sanitized) do
      described_class.call(default: default, only: only, skipped: skipped, allow_destroy: allow_destroy)
    end

    let(:op_class1) { Class.new }
    let(:op_class2) { Class.new }
    let(:op_class3) { Class.new }
    let(:allow_destroy) { false }

    context 'when the operations passed are mutations' do
      let(:skipped)  { [] }
      let(:only)     { [] }
      let(:default)  { { operation1: { klass: op_class1 }, operation2: { klass: op_class2 } } }

      context 'when no other option besides default is passed' do
        it { is_expected.to eq(default) }
      end

      context 'when there are only operations' do
        let(:only) { [:operation1] }

        it { is_expected.to eq(operation1: { klass: op_class1 }) }
      end

      context 'when there are skipped operations' do
        let(:skipped) { [:operation2] }

        it { is_expected.to eq(operation1: { klass: op_class1 }) }
      end
    end

    context 'when an operation requires the allow_destroy option' do
      let(:skipped) { [] }
      let(:only)    { [] }
      let(:default) do
        {
          operation1:      { klass: op_class1 },
          destroy_account: { klass: op_class2, allow_destroy: true }
        }
      end

      context 'when no only/skip option and allow_destroy is off' do
        it 'excludes the operation and logs a warning' do
          expect(Rails.logger).to receive(:warn).with(/destroy_account/)
          expect(sanitized).to eq(operation1: { klass: op_class1 })
        end
      end

      context 'when using skip on other operations without allow_destroy' do
        let(:skipped) { [:operation1] }

        it 'still excludes the operation and logs a warning' do
          expect(Rails.logger).to receive(:warn).with(/destroy_account/)
          expect(sanitized).to eq({})
        end
      end

      context 'when the operation itself is skipped' do
        let(:skipped) { [:destroy_account] }

        it 'excludes the operation without logging a warning' do
          expect(Rails.logger).not_to receive(:warn)
          expect(sanitized).to eq(operation1: { klass: op_class1 })
        end
      end

      context 'when allow_destroy is on' do
        let(:allow_destroy) { true }

        it 'includes the operation without warning' do
          expect(Rails.logger).not_to receive(:warn)
          expect(sanitized).to eq(default)
        end
      end

      context 'when named explicitly in only' do
        let(:only) { [:destroy_account] }

        it 'includes the operation without warning' do
          expect(Rails.logger).not_to receive(:warn)
          expect(sanitized).to eq(destroy_account: { klass: op_class2, allow_destroy: true })
        end
      end
    end
  end
end
