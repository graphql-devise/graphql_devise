# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GraphqlDevise::GraphqlController do
  let(:password) { 'password123' }
  let(:user)     { create(:user, :confirmed, password: password) }
  let(:params)   { { query: query, variables: variables } }

  context 'when variables are a string' do
    let(:variables) { "{\"email\": \"#{user.email}\"}" }
    let(:query)     { "mutation($email: String!) { userLogin(email: $email, password: \"#{password}\") { user { email name signInCount } } }" }

    it 'parses the string variables' do
      post_request('/api/v1/graphql_auth')

      expect(json_response).to match(
        data: { userLogin: { user: { email: user.email, name: user.name, signInCount: 1 } } }
      )
    end

    context 'when variables is an empty string' do
      let(:variables) { '' }
      let(:query)     { "mutation { userLogin(email: \"#{user.email}\", password: \"#{password}\") { user { email name signInCount } } }" }

      it 'returns an empty hash as variables' do
        post_request('/api/v1/graphql_auth')

        expect(json_response).to match(
          data: { userLogin: { user: { email: user.email, name: user.name, signInCount: 1 } } }
        )
      end
    end
  end

  context 'when variables are not a string or hash' do
    let(:variables) { 1 }
    let(:query)     { "mutation($email: String!) { userLogin(email: $email, password: \"#{password}\") { user { email name signInCount } } }" }

    it 'raises an error' do
      expect do
        post_request('/api/v1/graphql_auth')
      end.to raise_error(ArgumentError)
    end
  end

  context 'when multiplexing queries' do
    let(:params) do
      {
        _json: [
          { query: "mutation { userLogin(email: \"#{user.email}\", password: \"#{password}\") { user { email name signInCount } } }" },
          { query: "mutation { userLogin(email: \"#{user.email}\", password: \"wrong password\") { user { email name signInCount } } }" }
        ]
      }
    end

    it 'executes multiple queries in the same request' do
      post_request('/api/v1/graphql_auth')

      expect(json_response).to match(
        [
          { data: { userLogin: { user: { email: user.email, name: user.name, signInCount: 1 } } } },
          {
            data:   { userLogin: nil },
            errors: [
              hash_including(
                message: 'Invalid login credentials. Please try again.', extensions: { code: 'USER_ERROR' }
              )
            ]
          }
        ]
      )
    end
  end

  def post_request(path)
    if Rails::VERSION::MAJOR >= 5
      post(path, params: params)
    else
      post(path, params)
    end
  end
end
