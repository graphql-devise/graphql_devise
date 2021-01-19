# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Update Password With Token' do
  include_context 'with graphql query request'

  let(:password)              { '12345678' }
  let(:password_confirmation) { password }

  context 'when using the user model' do
    let(:user) { create(:user, :confirmed) }
    let(:query) do
      <<-GRAPHQL
        mutation {
          userUpdatePasswordWithToken(
            resetPasswordToken: "#{token}",
            password: "#{password}",
            passwordConfirmation: "#{password_confirmation}"
          ) {
            authenticatable { email }
            credentials { accessToken }
          }
        }
      GRAPHQL
    end

    context 'when reset password token is valid' do
      let(:token) { user.send(:set_reset_password_token) }

      it 'updates the password' do
        expect do
          post_request
          user.reload
        end.to change(user, :encrypted_password)

        expect(user).to be_valid_password(password)
        expect(json_response[:data][:userUpdatePasswordWithToken][:credentials]).to     be_nil
        expect(json_response[:data][:userUpdatePasswordWithToken][:authenticatable]).to include(email: user.email)
      end

      context 'when token has expired' do
        it 'returns an expired token error' do
          travel_to 10.hours.ago do
            token
          end

          post_request

          expect(json_response[:errors]).to contain_exactly(
            hash_including(message: 'Reset password token is no longer valid.', extensions: { code: 'USER_ERROR' })
          )
        end
      end

      context 'when password confirmation does not match' do
        let(:password_confirmation) { 'does not match' }

        it 'returns an error' do
          post_request

          expect(json_response[:errors]).to contain_exactly(
            hash_including(
              message:    'Unable to update user password',
              extensions: { code: 'USER_ERROR', detailed_errors: ["Password confirmation doesn't match Password"] }
            )
          )
        end
      end
    end

    context 'when reset password token is not found' do
      let(:token) { user.send(:set_reset_password_token) + 'invalid' }

      it 'returns an error' do
        post_request

        expect(json_response[:errors]).to contain_exactly(
          hash_including(message: 'No user found for the specified reset token.', extensions: { code: 'USER_ERROR' })
        )
      end
    end
  end

  context 'when using the admin model' do
    let(:admin) { create(:admin, :confirmed) }
    let(:query) do
      <<-GRAPHQL
        mutation {
          adminUpdatePasswordWithToken(
            resetPasswordToken: "#{token}",
            password: "#{password}",
            passwordConfirmation: "#{password_confirmation}"
          ) {
            authenticatable { email }
            credentials { uid }
          }
        }
      GRAPHQL
    end

    context 'when reset password token is valid' do
      let(:token) { admin.send(:set_reset_password_token) }

      it 'updates the password' do
        expect do
          post_request
          admin.reload
        end.to change(admin, :encrypted_password)

        expect(admin).to be_valid_password(password)
        expect(json_response[:data][:adminUpdatePasswordWithToken]).to include(
          credentials:     { uid: admin.email },
          authenticatable: { email: admin.email }
        )
      end
    end
  end
end
