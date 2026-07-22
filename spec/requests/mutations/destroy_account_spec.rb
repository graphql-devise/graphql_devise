# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Destroy Account Requests' do
  include_context 'with graphql query request'

  let(:user) { create(:user, :confirmed) }
  let(:query) do
    <<-GRAPHQL
      mutation {
        userDestroyAccount {
          authenticatable { email }
        }
      }
    GRAPHQL
  end

  before { post_request }

  context 'when user is logged in' do
    let(:headers) { user.create_new_auth_token }

    it 'destroys the account and does not set auth headers' do
      expect(response).not_to include_auth_headers
      expect(User.exists?(user.id)).to be(false)
      expect(json_response[:data][:userDestroyAccount]).to match(
        authenticatable: { email: user.email }
      )
      expect(json_response[:errors]).to be_nil
    end
  end

  context 'when user is not logged in' do
    it 'returns an error and does not delete anything' do
      expect(response).not_to include_auth_headers
      expect(User.exists?(user.id)).to be(true)
      expect(json_response[:data][:userDestroyAccount]).to be_nil
      expect(json_response[:errors]).to contain_exactly(
        hash_including(message: 'User was not found or was not logged in.', extensions: { code: 'USER_ERROR' })
      )
    end
  end

  context 'when using the admin model' do
    let(:query) do
      <<-GRAPHQL
        mutation {
          adminDestroyAccount {
            authenticatable { email }
          }
        }
      GRAPHQL
    end
    let(:admin)   { create(:admin, :confirmed) }
    let(:headers) { admin.create_new_auth_token }

    it 'destroys the admin account' do
      expect(response).not_to include_auth_headers
      expect(Admin.exists?(admin.id)).to be(false)
      expect(json_response[:data][:adminDestroyAccount]).to match(
        authenticatable: { email: admin.email }
      )
      expect(json_response[:errors]).to be_nil
    end
  end
end
