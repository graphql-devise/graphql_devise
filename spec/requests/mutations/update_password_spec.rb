# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Update Password Requests' do
  shared_examples 'successful password update' do
    it 'updates the password' do
      expect do
        post_request
        user.reload
      end.to change(user, :encrypted_password)

      expect(response).to include_auth_headers
      expect(json_response[:data][:userUpdatePassword]).to match(
        authenticatable: { email: user.email }
      )
      expect(json_response[:errors]).to be_nil
      expect(user).to be_valid_password(password)
    end
  end

  include_context 'with graphql query request'

  let(:password)              { 'safePassw0rd!' }
  let(:password_confirmation) { 'safePassw0rd!' }
  let(:original_password)     { 'current_password' }
  let(:current_password)      { original_password }
  let(:allow_password_change) { false }
  let(:user)                  { create(:user, :confirmed, password: original_password, allow_password_change: allow_password_change) }
  let(:query) do
    <<-GRAPHQL
      mutation {
        userUpdatePassword(
          password: "#{password}",
          passwordConfirmation: "#{password_confirmation}",
          currentPassword: "#{current_password}"
        ) {
          authenticatable { email }
        }
      }
    GRAPHQL
  end

  context 'when user is logged in' do
    let(:headers) { user.create_new_auth_token }

    context 'when currentPassword is not provided' do
      let(:current_password) { nil }

      context 'when allow_password_change is true' do
        let(:allow_password_change) { true }

        it_behaves_like 'successful password update'

        it 'sets allow_password_change to false' do
          expect do
            post_request
            user.reload
          end.to change(user, :allow_password_change).from(true).to(false)
        end
      end

      context 'when allow_password_change is false' do
        it 'does not update the password' do
          expect do
            post_request
            user.reload
          end.not_to change(user, :encrypted_password)

          expect(response).to include_auth_headers
          expect(json_response[:data][:userUpdatePassword]).to be_nil
          expect(json_response[:errors]).to contain_exactly(
            hash_including(
              message:    'Unable to update user password',
              extensions: { code: 'USER_ERROR', detailed_errors: ["Current password can't be blank"] }
            )
          )
        end
      end
    end

    context 'when currentPassword is provided' do
      context 'when allow_password_change is true' do
        let(:allow_password_change) { true }

        it_behaves_like 'successful password update'

        it 'sets allow_password_change to false' do
          expect do
            post_request
            user.reload
          end.to change(user, :allow_password_change).from(true).to(false)
        end
      end

      context 'when allow_password_change is false' do
        it_behaves_like 'successful password update'
      end
    end
  end

  context 'when user is not logged in' do
    it 'does not update the password' do
      expect do
        post_request
        user.reload
      end.not_to change(user, :encrypted_password)

      expect(response).not_to include_auth_headers
      expect(json_response[:data][:userUpdatePassword]).to be_nil
      expect(json_response[:errors]).to contain_exactly(
        hash_including(message: 'User is not logged in.', extensions: { code: 'USER_ERROR' })
      )
    end
  end
end
