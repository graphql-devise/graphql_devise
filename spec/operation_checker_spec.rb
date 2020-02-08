require 'rails_helper'

RSpec.describe GraphqlDevise::OperationChecker do
  describe '.call' do
    subject(:result) do
      -> {
        described_class.call(
          mutations: mutations,
          queries:   queries,
          custom:    custom,
          only:      only,
          skipped:   skipped
        )
      }
    end

    let(:mutations) { { mutation_1: Class.new, mutation_2: Class.new } }
    let(:queries)   { { query_1: Class.new, query_2: Class.new } }
    let(:custom)    { {} }
    let(:only)      { [] }
    let(:skipped)   { [] }

    context 'when there are not custom, only nor skipped operations' do
      it { is_expected.not_to raise_error }
    end

    context 'when custom mutations and queries passed are among the defaults' do
      let(:custom) { { mutation_1: Class.new, query_2: Class.new } }

      it { is_expected.not_to raise_error }
    end

    context 'when only operations are among the defaults' do
      let(:only) { [:mutation_1, :query_2] }

      it { is_expected.not_to raise_error }
    end

    context 'when skipped operations are among the defaults' do
      let(:skipped) { [:mutation_2, :query_1] }

      it { is_expected.not_to raise_error }
    end

    context 'when custom operations include a not supported item' do
      let(:custom) { { mutation_3: Class.new, query_2: Class.new } }

      it {
        is_expected.to(
          raise_error(
            GraphqlDevise::Error,
            'One of the custom operations is not supported. Check for typos.'
          )
        )
      }
    end

    context 'when only and skipped operations are both defined' do
      let(:only)    { [:mutation_1, :query_2] }
      let(:skipped) { [:mutation_2, :query_1] }

      it {
        is_expected.to(
          raise_error(
            GraphqlDevise::Error,
            "Can't specify both `skip` and `only` options when mounting the route."
          )
        )
      }
    end

    context 'when only operations include a not supported item' do
      let(:only) { [:mutation_3, :query_2] }

      it {
        is_expected.to(
          raise_error(
            GraphqlDevise::Error,
            'One of the `only` operations is not supported. Check for typos.'
          )
        )
      }
    end

    context 'when skipped operations include a not supported item' do
      let(:skipped) { [:mutation_3, :query_2] }

      it {
        is_expected.to(
          raise_error(
            GraphqlDevise::Error,
            'Trying to skip a non supported operation. Check for typos.'
          )
        )
      }
    end
  end
end
