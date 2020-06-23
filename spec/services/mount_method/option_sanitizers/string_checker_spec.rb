# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GraphqlDevise::MountMethod::OptionSanitizers::StringChecker do
  describe '#call!' do
    subject(:clean_value) { described_class.new(default_string).call!(value, key) }

    let(:key)            { :any_option }
    let(:default_string) { 'default string' }

    context 'when no value is provided' do
      let(:value) { nil }

      it { is_expected.to eq(default_string) }
    end

    context 'when provided value is not a String' do
      let(:value) { 1000 }

      it 'raises an error' do
        expect { clean_value }.to raise_error(GraphqlDevise::InvalidMountOptionsError, "`#{key}` option has an invalid value. String expected.")
      end
    end

    context 'when provided array contains all valid elements' do
      let(:value) { 'custom valid string' }

      it { is_expected.to eq(value) }
    end
  end
end
