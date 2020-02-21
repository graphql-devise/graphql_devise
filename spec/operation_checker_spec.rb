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

    let(:mutations) { { mutation1: Class.new, mutation2: Class.new } }
    let(:queries)   { { query1: Class.new, query2: Class.new } }
    let(:custom)    { {} }
    let(:only)      { [] }
    let(:skipped)   { [] }

    context 'when there are not custom, only nor skipped operations' do
      it { is_expected.not_to raise_error }
    end

    context 'when custom mutations and queries passed are among the defaults' do
      let(:custom) { { mutation1: Class.new, query2: Class.new } }

      it { is_expected.not_to raise_error }
    end

    context 'when only operations are among the defaults' do
      let(:only) { [:mutation1, :query2] }

      it { is_expected.not_to raise_error }
    end

    context 'when skipped operations are among the defaults' do
      let(:skipped) { [:mutation2, :query1] }

      it { is_expected.not_to raise_error }
    end

    context 'when only and skipped operations are both defined' do
      let(:only)    { [:mutation1, :query2] }
      let(:skipped) { [:mutation2, :query1] }

      it {
        is_expected.to(
          raise_error(
            GraphqlDevise::Error,
            "Can't specify both `skip` and `only` options when mounting the route."
          )
        )
      }
    end

    context 'when custom operations include a not supported item' do
      let(:custom) { { mutation3: Class.new, query2: Class.new } }

      it {
        is_expected.to(
          raise_error(
            GraphqlDevise::Error,
            'Custom operation "mutation3" is not supported. Check for typos.'
          )
        )
      }
    end

    context 'when skipped operations include a not supported item' do
      let(:skipped) { [:mutation3, :query2] }

      it {
        is_expected.to(
          raise_error(
            GraphqlDevise::Error,
            'Trying to skip unsupported operation "mutation3". Check for typos.'
          )
        )
      }
    end

    context 'when only operations include a not supported item' do
      let(:only) { [:mutation3, :query2] }

      it {
        is_expected.to(
          raise_error(
            GraphqlDevise::Error,
            'The "only" operation "mutation3" is not supported. Check for typos.'
          )
        )
      }
    end
  end
end
