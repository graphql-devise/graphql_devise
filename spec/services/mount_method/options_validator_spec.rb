# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GraphqlDevise::MountMethod::OptionsValidator do
  describe '#validate!' do
    subject { -> { described_class.new([validator1, validator2]).validate! } }

    let(:validator1) { double(:validator1, 'validate!': nil) }
    let(:validator2) { double(:validator2, 'validate!': nil) }

    context 'when first validator fails' do
      before { allow(validator1).to receive(:validate!).and_raise(GraphqlDevise::InvalidMountOptionsError, 'validator1 error') }

      context 'when second validator fails' do
        before { allow(validator2).to receive(:validate!).and_raise(GraphqlDevise::InvalidMountOptionsError, 'validator2 error') }

        it { is_expected.to raise_error(GraphqlDevise::InvalidMountOptionsError, 'validator1 error') }
      end

      context 'when second validator does not fail' do
        it { is_expected.to raise_error(GraphqlDevise::InvalidMountOptionsError, 'validator1 error') }
      end
    end

    context 'when first validator does not fail' do
      context 'when second validator fails' do
        before { allow(validator2).to receive(:validate!).and_raise(GraphqlDevise::InvalidMountOptionsError, 'validator2 error') }

        it { is_expected.to raise_error(GraphqlDevise::InvalidMountOptionsError, 'validator2 error') }
      end

      context 'when second validator does not fail' do
        it { is_expected.not_to raise_error }
      end
    end
  end
end
