# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Logout Requests' do
  include_context 'with graphql query request'

  let(:user) { create(:user, :confirmed) }
  let(:query) do
    <<-GRAPHQL
      mutation {
        userLogout {
          authenticatable { email }
        }
      }
    GRAPHQL
  end

  before { post_request }

  context 'when user is logged in' do
    let(:headers) { user.create_new_auth_token }

    it 'logs out the user' do
      expect(response).not_to include_auth_headers
      expect(user.reload.tokens.keys).to be_empty
      expect(json_response[:data][:userLogout]).to match(
        authenticatable: { email: user.email }
      )
      expect(json_response[:errors]).to be_nil
    end
  end

  context 'when user is not logged in' do
    it 'returns an error' do
      expect(response).not_to include_auth_headers
      expect(user.reload.tokens.keys).to be_empty
      expect(json_response[:data][:userLogout]).to be_nil
      expect(json_response[:errors]).to contain_exactly(
        hash_including(message: 'User was not found or was not logged in.', extensions: { code: 'USER_ERROR' })
      )
    end
  end

  context 'when using the admin model' do
    let(:query) do
      <<-GRAPHQL
        mutation {
          adminLogout {
            authenticatable { email }
          }
        }
      GRAPHQL
    end
    let(:admin)   { create(:admin, :confirmed) }
    let(:headers) { admin.create_new_auth_token }

    it 'logs out the admin' do
      expect(response).not_to include_auth_headers
      expect(admin.reload.tokens.keys).to be_empty
      expect(json_response[:data][:adminLogout]).to match(
        authenticatable: { email: admin.email }
      )
      expect(json_response[:errors]).to be_nil
    end
  end
end
