require 'rails_helper'

RSpec.describe 'Logout Requests' do
  include_context 'with graphql query request'

  let(:user) { create(:user, :confirmed) }
  let(:query) do
    <<-GRAPHQL
      mutation {
        userLogout{
          authenticable { email }
          success
          errors
        }
      }
    GRAPHQL
  end

  before { post '/api/v1/graphql_auth', *graphql_params }

  context 'when user is logged in' do
    let(:headers) { user.create_new_auth_token }

    it 'logs out the user' do
      expect(response).not_to include_auth_headers
      expect(user.reload.tokens.keys).to be_empty
      expect(json_response[:data][:userLogout]).to match(
        success:       true,
        errors:        [],
        authenticable: { email: user.email }
      )
    end
  end

  context 'when user is not logged in' do
    it 'returns an error' do
      expect(response).not_to include_auth_headers
      expect(user.reload.tokens.keys).to be_empty
      expect(json_response[:data][:userLogout]).to match(
        success:       false,
        errors:        ['User was not found or was not logged in.'],
        authenticable: nil
      )
    end
  end
end
