# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GraphqlDevise::MountMethod::OptionValidators::ProvidedOperationsValidator do
  describe '#validate!' do
    subject { -> { described_class.new(options: provided_operations, supported_operations: supported_operations).validate! } }

    let(:supported_operations) { { operation1: 'irrelevant', operation2: 'irrelevant', operation3: 'irrelevant' } }

    context 'when skip option is provided' do
      let(:provided_operations) { double(:clean_options, only: [], skip: skipped, operations: {}) }

      context 'when all skipped are supported' do
        let(:skipped) { [:operation2, :operation3] }

        it { is_expected.not_to raise_error }
      end

      context 'when skipped contains unsupported operations' do
        let(:skipped) { [:operation2, :operation3, :invalid] }

        it { is_expected.to raise_error(GraphqlDevise::InvalidMountOptionsError, 'skip option contains unsupported operations: "invalid". Check for typos.') }
      end
    end

    context 'when only option is provided' do
      let(:provided_operations) { double(:clean_options, skip: [], only: only, operations: {}) }

      context 'when all only are supported' do
        let(:only) { [:operation2, :operation3] }

        it { is_expected.not_to raise_error }
      end

      context 'when only contains unsupported operations' do
        let(:only) { [:operation2, :operation3, :invalid] }

        it { is_expected.to raise_error(GraphqlDevise::InvalidMountOptionsError, 'only option contains unsupported operations: "invalid". Check for typos.') }
      end
    end

    context 'when operations option is provided' do
      let(:provided_operations) { double(:clean_options, only: [], skip: [], operations: operations) }

      context 'when all operations are supported' do
        let(:operations) { { operation2: 'irrelevant', operation3: 'irrelevant' } }

        it { is_expected.not_to raise_error }
      end

      context 'when operations contains unsupported operations' do
        let(:operations) { { operation2: 'irrelevant', operation3: 'irrelevant', invalid: 'invalid' } }

        it { is_expected.to raise_error(GraphqlDevise::InvalidMountOptionsError, 'operations option contains unsupported operations: "invalid". Check for typos.') }
      end
    end
  end
end
