# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Account confirmation' do
  include_context 'with graphql query request'

  context 'when using the user model' do
    let(:user)     { create(:user, confirmed_at: nil) }
    let(:redirect) { 'https://google.com' }
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

        expect(response).to redirect_to("#{redirect}?account_confirmation_success=true")
        expect(user).to be_active_for_authentication
      end

      context 'when redirect_url is not whitelisted' do
        let(:redirect) { 'https://not-safe.com' }

        it 'returns a not whitelisted redirect url error' do
          expect { post_request }.to not_change(ActionMailer::Base.deliveries, :count)

          expect(json_response[:errors]).to containing_exactly(
            hash_including(
              message:    "Redirect to '#{redirect}' not allowed.",
              extensions: { code: 'USER_ERROR' }
            )
          )
        end
      end

      context 'when unconfirmed_email is present' do
        let(:user) { create(:user, :confirmed, unconfirmed_email: 'vvega@wallaceinc.com') }

        it 'confirms the unconfirmed email and redirects' do
          expect do
            get_request
            user.reload
          end.to change(user, :email).from(user.email).to('vvega@wallaceinc.com').and(
            change(user, :unconfirmed_email).from('vvega@wallaceinc.com').to(nil)
          )

          expect(response).to redirect_to("#{redirect}?account_confirmation_success=true")
        end
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
            message:    'Invalid confirmation token. Please try again',
            extensions: { code: 'USER_ERROR' }
          )
        )
      end
    end
  end

  context 'when using the admin model' do
    let(:admin)    { create(:admin, confirmed_at: nil) }
    let(:redirect) { 'https://google.com' }
    let(:query) do
      <<-GRAPHQL
        {
          adminConfirmAccount(
            confirmationToken: "#{token}"
            redirectUrl:       "#{redirect}"
          ) {
            email
          }
        }
      GRAPHQL
    end

    context 'when confirmation token is correct' do
      let(:token) { admin.confirmation_token }

      before do
        admin.send_confirmation_instructions(
          template_path: ['graphql_devise/mailer'],
          controller:    'graphql_devise/graphql',
          schema_url:    'http://not-using-this-value.com/gql'
        )
      end

      it 'confirms the resource, persists credentials on the DB and redirects to the sent url' do
        expect do
          get_request
          admin.reload
        end.to change(admin, :confirmed_at).from(nil).and(
          change { admin.tokens.keys.count }.from(0).to(1)
        )

        expect(response).to redirect_to(/\A#{redirect}.+access\-token=/)
        expect(admin).to be_active_for_authentication
      end
    end
  end
end
