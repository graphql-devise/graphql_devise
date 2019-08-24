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

  before { post '/api/v1/graphql_auth', *graphql_params }

  context 'when user is able to login' do
    context 'when credentials are valid' do
      it 'return credentials in headers and user information' do
        expect(response).to include_auth_headers
        expect(user.reload.tokens.keys).to include(response.headers['client'])
        expect(json_response.dig(:data, :login)).to match(
          success:       true,
          errors:        [],
          authenticable: { email: user.email }
        )
      end
    end

    context 'when credentials are invalid' do
      let(:user) { create(:user, :confirmed, password: 'not guessing it ;)') }

      it 'returns bad credentials error' do
        expect(response).not_to include_auth_headers
        expect(json_response.dig(:data, :login)).to match(
          success:       false,
          errors:        ['Invalid login credentials. Please try again.'],
          authenticable: nil
        )
      end
    end
  end

  context 'when user is not confirmed' do
    let(:user) { create(:user, password: password) }

    it 'returns a must confirm account message' do
      expect(response).not_to include_auth_headers
      expect(json_response.dig(:data, :login)).to match(
        success:       false,
        errors:        [
          "A confirmation email was sent to your account at '#{user.email}'. You must follow the instructions in the " \
          "email before your account can be activated"
        ],
        authenticable: nil
      )
    end
  end

  context 'when user is locked' do
    let(:user) { create(:user, :confirmed, :locked, password: password) }

    it 'returns a must confirm account message' do
      expect(response).not_to include_auth_headers
      expect(json_response.dig(:data, :login)).to match(
        success:       false,
        errors:        ['Your account has been locked due to an excessive number of unsuccessful sign in attempts.'],
        authenticable: nil
      )
    end
  end

  context 'when invalid for authentication' do
    let(:user) { create(:user, :confirmed, :auth_unavailable, password: password) }

    it 'returns a must confirm account message' do
      expect(response).not_to include_auth_headers
      expect(json_response.dig(:data, :login)).to match(
        success:       false,
        errors:        ['Invalid login credentials. Please try again.'  ],
        authenticable: nil
      )
    end
  end
end
