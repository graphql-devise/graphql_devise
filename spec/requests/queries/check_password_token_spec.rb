# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Check Password Token Requests' do
  include_context 'with graphql query request'

  let(:user)         { create(:user, :confirmed) }
  let(:redirect_url) { 'https://google.com' }

  context 'when using the user model' do
    let(:query) do
      <<-GRAPHQL
        query {
          userCheckPasswordToken(
            resetPasswordToken: "#{token}",
            redirectUrl: "#{redirect_url}"
          ) {
            email
          }
        }
      GRAPHQL
    end

    context 'when reset password token is valid' do
      let(:token) { user.send(:set_reset_password_token) }

      context 'when redirect_url is not provided' do
        let(:redirect_url) { nil }

        it 'returns authenticatable and credentials in the headers' do
          get_request

          expect(response).to include_auth_headers
          expect(json_response[:data][:userCheckPasswordToken]).to match(
            email: user.email
          )
        end
      end

      context 'when redirect url is provided' do
        it 'redirects to redirect url' do
          expect do
            get_request

            user.reload
          end.to change { user.tokens.keys.count }.from(0).to(1).and(
            change(user, :allow_password_change).from(false).to(true)
          )

          expect(response).to      redirect_to %r{\Ahttps://google.com}
          expect(response.body).to include("client=#{user.reload.tokens.keys.first}")
          expect(response.body).to include('access-token=')
          expect(response.body).to include('uid=')
          expect(response.body).to include('expiry=')
        end

        context 'when redirect_url is not whitelisted' do
          let(:redirect_url) { 'https://not-safe.com' }

          before { post_request }

          it 'returns a not whitelisted redirect url error' do
            expect(json_response[:errors]).to containing_exactly(
              hash_including(
                message:    "Redirect to '#{redirect_url}' not allowed.",
                extensions: { code: 'USER_ERROR' }
              )
            )
          end
        end
      end

      context 'when token has expired' do
        it 'returns an expired token error' do
          travel_to 10.hours.ago do
            token
          end

          get_request

          expect(json_response[:errors]).to contain_exactly(
            hash_including(message: 'Reset password token is no longer valid.', extensions: { code: 'USER_ERROR' })
          )
        end
      end
    end

    context 'when reset password token is not found' do
      let(:token) { user.send(:set_reset_password_token) + 'invalid' }

      it 'returns an error message' do
        get_request

        expect(json_response[:errors]).to contain_exactly(
          hash_including(message: 'No user found for the specified reset token.', extensions: { code: 'USER_ERROR' })
        )
      end
    end
  end

  context 'when using the admin model' do
    let(:token) { 'not_important' }
    let(:query) do
      <<-GRAPHQL
        query {
          adminCheckPasswordToken(
            resetPasswordToken: "#{token}",
            redirectUrl: "#{redirect_url}"
          ) {
            email
          }
        }
      GRAPHQL
    end

    before { post_request }

    it 'skips the sign up mutation' do
      expect(json_response[:errors]).to contain_exactly(
        hash_including(message: "Field 'adminCheckPasswordToken' doesn't exist on type 'Query'")
      )
    end
  end

  context 'when using the guest model' do
    let(:token) { 'not_important' }
    let(:query) do
      <<-GRAPHQL
        query {
          guestCheckPasswordToken(
            resetPasswordToken: "#{token}",
            redirectUrl: "#{redirect_url}"
          ) {
            email
          }
        }
      GRAPHQL
    end

    before { post_request }

    it 'skips the sign up mutation' do
      expect(json_response[:errors]).to contain_exactly(
        hash_including(message: "Field 'guestCheckPasswordToken' doesn't exist on type 'Query'")
      )
    end
  end
end
