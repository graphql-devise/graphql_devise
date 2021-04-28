# frozen_string_literal: true

RSpec.shared_context 'with graphql query request' do
  let(:headers)   { {} }
  let(:variables) { {} }
  let(:graphql_params) do
    if Rails::VERSION::MAJOR >= 5
      { params: { query: query, variables: variables }, headers: headers }
    else
      [{ query: query, variables: variables }, headers]
    end
  end

  def post_request(path = '/api/v1/graphql_auth')
    send_request(path, :post)
  end

  def get_request(path = '/api/v1/graphql_auth')
    send_request(path, :get)
  end

  def send_request(path, method)
    if Rails::VERSION::MAJOR >= 5
      public_send(method, path, **graphql_params)
    else
      public_send(method, path, *graphql_params)
    end
  end
end
