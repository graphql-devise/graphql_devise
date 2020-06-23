# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GraphqlDevise::MountMethod::OptionSanitizers::ClassChecker do
  describe '#call!' do
    subject(:clean_value) { described_class.new(expected_class).call!(value, key) }

    let(:key)            { :any_option }
    let(:expected_class) { Numeric }

    context 'when no value is provided' do
      let(:value) { nil }

      it { is_expected.to eq(nil) }
    end

    context 'when provided value is not a class' do
      let(:value) { 'I\'m not a class' }

      it 'raises an error' do
        expect { clean_value }.to raise_error(GraphqlDevise::InvalidMountOptionsError, "`#{key}` option has an invalid value. Class expected.")
      end
    end

    context 'when provided class is not of the expected type' do
      let(:value) { String }

      it 'raises an error' do
        expect { clean_value }.to raise_error(GraphqlDevise::InvalidMountOptionsError, "`#{key}` option has an invalid value. #{expected_class} or descendants expected. Got String.")
      end
    end

    context 'when provided class is of the expected type' do
      let(:value) { Numeric }

      it { is_expected.to eq(value) }
    end

    context 'when provided class has the expected type as an acestor' do
      let(:value) { Float }

      it { is_expected.to eq(value) }
    end
  end
end
