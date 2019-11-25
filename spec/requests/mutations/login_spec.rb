require 'rails_helper'

RSpec.describe 'Login Requests' do
  include_context 'with graphql query request'

  let(:password) { '12345678' }

  context 'when using the user model' do
    let(:user) { create(:user, :confirmed, password: password) }
    let(:query) do
      <<-GRAPHQL
        mutation {
          userLogin(
            email: "#{user.email}",
            password: "#{password}"
          ) {
            user { email name signInCount }
          }
        }
      GRAPHQL
    end

    before { post_request }

    context 'when user is able to login' do
      context 'when credentials are valid' do
        it 'return credentials in headers and user information' do
          expect(response).to include_auth_headers
          expect(user.reload.tokens.keys).to include(response.headers['client'])
          expect(json_response[:data][:userLogin]).to match(
            user: { email: user.email, name: user.name, signInCount: 1 }
          )
          expect(json_response[:errors]).to be_nil
        end
      end

      context 'when credentials are invalid' do
        let(:user) { create(:user, :confirmed, password: 'not guessing it ;)') }

        it 'returns bad credentials error' do
          expect(response).not_to include_auth_headers
          expect(json_response[:data][:userLogin]).to be_nil
          expect(json_response[:errors]).to contain_exactly(
            hash_including(message: 'Invalid login credentials. Please try again.', extensions: { code: 'USER_ERROR' })
          )
        end
      end
    end

    context 'when user is not confirmed' do
      let(:user) { create(:user, password: password) }

      it 'returns a must confirm account message' do
        expect(response).not_to include_auth_headers
        expect(json_response[:data][:userLogin]).to be_nil
        expect(json_response[:errors]).to contain_exactly(
          hash_including(
            message:    "A confirmation email was sent to your account at '#{user.email}'. You must follow the " \
                        "instructions in the email before your account can be activated",
            extensions: { code: 'USER_ERROR' }
          )
        )
      end
    end

    context 'when user is locked' do
      let(:user) { create(:user, :confirmed, :locked, password: password) }

      it 'returns a must confirm account message' do
        expect(response).not_to include_auth_headers
        expect(json_response[:data][:userLogin]).to be_nil
        expect(json_response[:errors]).to contain_exactly(
          hash_including(
            message:    'Your account has been locked due to an excessive number of unsuccessful sign in attempts.',
            extensions: { code: 'USER_ERROR' }
          )
        )
      end
    end

    context 'when invalid for authentication' do
      let(:user) { create(:user, :confirmed, :auth_unavailable, password: password) }

      it 'returns a must confirm account message' do
        expect(response).not_to include_auth_headers
        expect(json_response[:data][:userLogin]).to be_nil
        expect(json_response[:errors]).to contain_exactly(
          hash_including(message: 'Invalid login credentials. Please try again.', extensions: { code: 'USER_ERROR' })
        )
      end
    end
  end

  context 'when using the admin model' do
    let(:admin) { create(:admin, :confirmed, password: password) }
    let(:query) do
      <<-GRAPHQL
        mutation {
          adminLogin(
            email: "#{admin.email}",
            password: "#{password}"
          ) {
            authenticatable { email customField }
          }
        }
      GRAPHQL
    end

    before { post_request('/api/v1/admin/graphql_auth') }

    it 'works alongside the user mount point' do
      expect(json_response[:data][:adminLogin]).to include(
        authenticatable: { email: admin.email, customField: "email: #{admin.email}" }
      )
    end
  end

  context 'when using the guest model' do
    let(:guest) { create(:guest, :confirmed, password: password) }
    let(:query) do
      <<-GRAPHQL
        mutation {
          guestLogin(
            email: "#{guest.email}",
            password: "#{password}"
          ) {
            authenticatable { email }
          }
        }
      GRAPHQL
    end

    before { post_request }

    it 'works alongside the user mount point' do
      expect(json_response[:data][:guestLogin]).to include(
        authenticatable: { email: guest.email }
      )
    end
  end
end
