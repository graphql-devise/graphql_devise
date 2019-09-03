RSpec.shared_context 'with graphql query request' do
  let(:headers)   { {} }
  let(:variables) { {} }
  let(:graphql_params) do
    if Rails::VERSION::MAJOR >= 5
      [{ params: { query: query, variables: variables }, headers: headers }]
    else
      [{ query: query, variables: variables }, headers]
    end
  end

  def post_request
    post '/api/v1/graphql_auth', *graphql_params
  end

  def get_request
    get '/api/v1/graphql_auth', *graphql_params
  end
end
