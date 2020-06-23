# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GraphqlDevise::MountMethod::OptionValidators::SupportedOperationsValidator do
  describe '#validate!' do
    subject { -> { described_class.new(provided_operations: provided_operations, supported_operations: supported_operations, key: key).validate! } }

    let(:supported_operations) { [:operation1, :operation2, :operation3] }
    let(:key)                  { :only }

    context 'when custom operations are all supported' do
      let(:provided_operations) { [:operation2, :operation3] }

      it { is_expected.not_to raise_error }
    end

    context 'when no operations are provided' do
      let(:provided_operations) { [] }

      it { is_expected.not_to raise_error }
    end

    context 'when default_operations are empty' do
      let(:supported_operations) { [] }
      let(:provided_operations) { [:invalid] }

      it { is_expected.to raise_error(GraphqlDevise::InvalidMountOptionsError, 'only option contains unsupported operations: "invalid". Check for typos.') }
    end

    context 'when not all custom operations are supported' do
      let(:provided_operations) { [:operation2, :operation3, :unsupported] }

      it { is_expected.to raise_error(GraphqlDevise::InvalidMountOptionsError, 'only option contains unsupported operations: "unsupported". Check for typos.') }
    end
  end
end
