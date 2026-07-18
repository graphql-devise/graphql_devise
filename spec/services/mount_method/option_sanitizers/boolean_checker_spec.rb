# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GraphqlDevise::MountMethod::OptionSanitizers::BooleanChecker do
  describe '#call!' do
    subject(:clean_value) { described_class.new(default_boolean).call!(value, key) }

    let(:key)             { :any_option }
    let(:default_boolean) { true }

    context 'when no value is provided' do
      let(:value) { nil }

      it { is_expected.to eq(default_boolean) }
    end

    context 'when provided value is false' do
      let(:value) { false }

      it 'preserves the explicit false value instead of falling back to the default' do
        expect(clean_value).to eq(false)
      end
    end

    context 'when provided value is true' do
      let(:value) { true }

      it { is_expected.to eq(true) }
    end

    context 'when provided value is not a boolean' do
      let(:value) { 'true' }

      it 'raises an error' do
        expect { clean_value }.to raise_error(GraphqlDevise::InvalidMountOptionsError, "`#{key}` option has an invalid value. `true` or `false` expected.")
      end
    end
  end
end
