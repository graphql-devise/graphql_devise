# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GraphqlDevise::MountMethod::OptionSanitizers::ArrayChecker do
  describe '#call!' do
    subject(:clean_value) { described_class.new(element_type).call!(value, key) }

    let(:key)          { :any_option }
    let(:element_type) { Symbol }

    context 'when no value is provided' do
      let(:value) { nil }

      it { is_expected.to eq([]) }
    end

    context 'when provided value is not an array' do
      let(:value) { 'not an array' }

      it 'raises an error' do
        expect { clean_value }.to raise_error(GraphqlDevise::InvalidMountOptionsError, "`#{key}` option has an invalid value. Array expected.")
      end
    end

    context 'when provided array contains invalid elements' do
      let(:value) { [:valid, 'invalid'] }

      it 'raises an error' do
        expect { clean_value }.to raise_error(GraphqlDevise::InvalidMountOptionsError, "`#{key}` option has invalid elements. #{element_type} expected.")
      end
    end

    context 'when provided array contains all valid elements' do
      let(:value) { [:valid1, :valid2] }

      it { is_expected.to eq(value) }
    end
  end
end
