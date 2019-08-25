RSpec.shared_context 'with graphql query request' do
  let(:variables) { {} }
  let(:graphql_params) do
    if Rails::VERSION::MAJOR >= 5
      [{ params: { query: query, variables: variables } }]
    else
      [{ query: query, variables: variables }]
    end
  end
end
