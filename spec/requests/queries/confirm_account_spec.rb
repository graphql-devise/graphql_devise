# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Account confirmation' do
  include_context 'with graphql query request'

  let(:user)     { create(:user, confirmed_at: nil) }
  let(:redirect) { Faker::Internet.url }
  let(:query) do
    <<-GRAPHQL
      {
        userConfirmAccount(
          confirmationToken: "#{token}"
          redirectUrl:       "#{redirect}"
        ) {
          email
          name
        }
      }
    GRAPHQL
  end

  context 'when confirmation token is correct' do
    let(:token) { user.confirmation_token }

    before do
      user.send_confirmation_instructions(
        template_path: ['graphql_devise/mailer'],
        controller:    'graphql_devise/graphql',
        schema_url:    'http://not-using-this-value.com/gql'
      )
    end

    it 'confirms the resource and redirects to the sent url' do
      expect do
        get_request
        user.reload
      end.to(change(user, :confirmed_at).from(nil))

      expect(response).to redirect_to "#{redirect}?account_confirmation_success=true"
      expect(user).to be_active_for_authentication
    end
  end

  context 'when reset password token is not found' do
    let(:token) { "#{user.confirmation_token}-invalid" }

    it 'does *NOT* confirm the user nor does the redirection' do
      expect do
        get_request
        user.reload
      end.not_to(change(user, :confirmed_at).from(nil))

      expect(response).not_to be_redirect
      expect(json_response[:errors]).to contain_exactly(
        hash_including(
          message: 'Invalid confirmation token. Please try again',
          extensions: { code: 'USER_ERROR' }
        )
      )
    end
  end
end
