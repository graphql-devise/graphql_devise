RSpec.shared_context 'with graphql query request' do
  let(:variables) { {} }
  let(:grapqhl_params) do
    { query: query, variables: variables }
  end
end
