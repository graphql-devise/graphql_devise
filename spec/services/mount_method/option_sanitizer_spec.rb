# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GraphqlDevise::MountMethod::OptionSanitizer do
  subject(:clean_options) { described_class.new(options, supported_options).call! }

  describe '#call!' do
    let(:supported_options) do
      {
        my_string:     GraphqlDevise::MountMethod::OptionSanitizers::StringChecker.new('default string'),
        hash_multiple: GraphqlDevise::MountMethod::OptionSanitizers::HashChecker.new([String, Numeric]),
        array:         GraphqlDevise::MountMethod::OptionSanitizers::ArrayChecker.new(Symbol),
        hash_single:   GraphqlDevise::MountMethod::OptionSanitizers::HashChecker.new(Float),
        my_class:      GraphqlDevise::MountMethod::OptionSanitizers::ClassChecker.new(Numeric)
      }
    end

    context 'when all options are provided and correct' do
      let(:options) do
        {
          my_string:     'non default',
          hash_multiple: { first: String, second: Float, third: Float },
          array:         [:one, :two, :three],
          hash_single:   { first: Float, second: Float },
          my_class:      Float
        }
      end

      it 'returns a struct with clean options' do
        expect(
          my_string:     clean_options.my_string,
          hash_multiple: clean_options.hash_multiple,
          array:         clean_options.array,
          hash_single:   clean_options.hash_single,
          my_class:      clean_options.my_class
        ).to match(
          my_string:     'non default',
          hash_multiple: { first: String, second: Float, third: Float },
          array:         [:one, :two, :three],
          hash_single:   { first: Float, second: Float },
          my_class:      Float
        )
      end
    end

    context 'when some options are provided but all correct' do
      let(:options) do
        {
          hash_multiple: { first: String, second: Float, third: Float },
          array:         [:one, :two, :three],
          my_class:      Float
        }
      end

      it 'returns a struct with clean options and default values' do
        expect(
          my_string:     clean_options.my_string,
          hash_multiple: clean_options.hash_multiple,
          array:         clean_options.array,
          hash_single:   clean_options.hash_single,
          my_class:      clean_options.my_class
        ).to match(
          my_string:     'default string',
          hash_multiple: { first: String, second: Float, third: Float },
          array:         [:one, :two, :three],
          hash_single:   {},
          my_class:      Float
        )
      end
    end

    context 'when an option provided is invalid' do
      let(:options) do
        {
          hash_multiple: { first: String, second: Float, third: Float },
          array:         ['not symbol 1', 'not symbol 2'],
          my_class:      Float
        }
      end

      it 'raises an error' do
        expect { clean_options }.to raise_error(GraphqlDevise::InvalidMountOptionsError, '`array` option has invalid elements. Symbol expected.')
      end
    end
  end
end
