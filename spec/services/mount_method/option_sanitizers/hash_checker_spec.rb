# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GraphqlDevise::MountMethod::OptionSanitizers::HashChecker do
  describe '#call!' do
    subject(:clean_value) { described_class.new(element_type).call!(value, key) }

    let(:key) { :any_option }

    context 'when a single valid type is provided' do
      let(:element_type) { Numeric }

      context 'when no value is provided' do
        let(:value) { nil }

        it { is_expected.to eq({}) }
      end

      context 'when provided value is not a hash' do
        let(:value) { 'not a hash' }

        it 'raises an error' do
          expect { clean_value }.to raise_error(GraphqlDevise::InvalidMountOptionsError, "`#{key}` option has an invalid value. Hash expected. Got String.")
        end
      end

      context 'when provided hash contains invalid elements' do
        let(:value) { { valid: Float, invalid: String } }

        it 'raises an error' do
          expect { clean_value }.to raise_error(GraphqlDevise::InvalidMountOptionsError, "`#{key} -> invalid` option has an invalid value. #{element_type} or descendants expected. Got #{String}.")
        end
      end

      context 'when provided array contains all valid elements' do
        let(:value) { { valid1: Numeric, valid2: Numeric } }

        it { is_expected.to eq(value) }
      end

      context 'when provided class has the expected type as an acestor' do
        let(:value) { { valid: Float } }

        it { is_expected.to eq(value) }
      end
    end

    context 'when multiple value types are allowed' do
      let(:element_type) { [String, Numeric] }

      context 'when no value is provided' do
        let(:value) { nil }

        it { is_expected.to eq({}) }
      end

      context 'when provided array contains all valid elements' do
        let(:value) { { valid1: String, valid2: Numeric } }

        it { is_expected.to eq(value) }
      end

      context 'when provided class has the expected type as an acestor' do
        let(:value) { { valid: Float } }

        it { is_expected.to eq(value) }
      end

      context 'when provided value is not a hash' do
        let(:value) { 'not a hash' }

        it 'raises an error' do
          expect { clean_value }.to raise_error(GraphqlDevise::InvalidMountOptionsError, "`#{key}` option has an invalid value. Hash expected. Got String.")
        end
      end

      context 'when provided hash contains invalid elements' do
        let(:value) { { valid: String, invalid: StandardError } }

        it 'raises an error' do
          expect { clean_value }.to raise_error(GraphqlDevise::InvalidMountOptionsError, "`#{key} -> invalid` option has an invalid value. #{element_type.join(', ')} or descendants expected. Got #{StandardError}.")
        end
      end
    end
  end
end
