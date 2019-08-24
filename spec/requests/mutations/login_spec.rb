require 'rails_helper'

RSpec.describe 'Login Requests' do
  include_context 'with graphql query request'

  let(:password) { '12345678' }
  let(:user)     { create(:user, :confirmed, password: password) }
  let(:query) do
    <<~GRAPHQL
      mutation {
        login(
          email: "#{user.email}",
          password: "#{password}"
        ) {
          authenticable { email }
          success
          errors
        }
      }
    GRAPHQL
  end

  context 'when user is able to login' do
    it 'return credentials in headers and user information' do
      post '/api/v1/graphql_auth', params: grapqhl_params

      auth_headers = %w[uid access-token client].map { |key| response.headers[key] }

      expect(auth_headers).to all(be_present)
      expect(user.reload.tokens.keys).to include(response.headers['client'])
      expect(json_response.dig(:data, :login)).to match(
        success:       true,
        errors:        [],
        authenticable: { email: user.email }
      )
    end
  end
end
