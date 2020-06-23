# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GraphqlDevise::MountMethod::OptionValidators::SkipOnlyValidator do
  describe '#validate!' do
    subject { -> { described_class.new(options: options).validate! } }

    context 'when only `only` key is set' do
      let(:options) { double(:clean_options, only: [:irrelevant], skip: []) }

      it { is_expected.not_to raise_error }
    end

    context 'when only `skip` key is set' do
      let(:options) { double(:clean_options, skip: [:irrelevant], only: []) }

      it { is_expected.not_to raise_error }
    end

    context 'when `skip` and `only` keys are set' do
      let(:options) { double(:clean_options, only: [:irrelevant], skip: [:irrelevant]) }

      it { is_expected.to raise_error(GraphqlDevise::InvalidMountOptionsError, "Can't specify both `skip` and `only` options when mounting the route.") }
    end

    context 'when neither `skip` nor `only are set`' do
      let(:options) { double(:clean_options, skip: [], only: []) }

      it { is_expected.not_to raise_error }
    end
  end
end
