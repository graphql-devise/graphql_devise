# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Registration confirmation with token' do
  include_context 'with graphql query request'

  context 'when using the user model' do
    let(:user) { create(:user, confirmed_at: nil) }
    let(:query) do
      <<-GRAPHQL
        mutation {
          userConfirmRegistrationWithToken(
            confirmationToken: "#{token}"
          ) {
            authenticatable {
              email
              name
            }
            credentials { client }
          }
        }
      GRAPHQL
    end

    context 'when confirmation token is correct' do
      let(:token) { user.confirmation_token }

      before do
        user.send_confirmation_instructions(
          template_path: ['graphql_devise/mailer']
        )
      end

      it 'confirms the resource and returns credentials' do
        expect do
          post_request
          user.reload
        end.to(change(user, :confirmed_at).from(nil))

        expect(json_response[:data][:userConfirmRegistrationWithToken]).to include(
          authenticatable: { email: user.email, name: user.name },
          credentials:     { client: user.tokens.keys.first }
        )

        expect(user).to be_active_for_authentication
      end

      context 'when unconfirmed_email is present' do
        let(:user) { create(:user, :confirmed, unconfirmed_email: 'vvega@wallaceinc.com') }

        it 'confirms the unconfirmed email' do
          expect do
            post_request
            user.reload
          end.to change(user, :email).from(user.email).to('vvega@wallaceinc.com').and(
            change(user, :unconfirmed_email).from('vvega@wallaceinc.com').to(nil)
          )
        end
      end
    end

    context 'when reset password token is not found' do
      let(:token) { "#{user.confirmation_token}-invalid" }

      it 'does *NOT* confirm the user' do
        expect do
          post_request
          user.reload
        end.not_to change(user, :confirmed_at).from(nil)

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
    let(:admin) { create(:admin, confirmed_at: nil) }
    let(:query) do
      <<-GRAPHQL
        mutation {
          adminConfirmRegistrationWithToken(
            confirmationToken: "#{token}"
          ) {
            authenticatable { email }
          }
        }
      GRAPHQL
    end

    context 'when confirmation token is correct' do
      let(:token) { admin.confirmation_token }

      before do
        admin.send_confirmation_instructions(
          template_path: ['graphql_devise/mailer']
        )
      end

      it 'confirms the resource and persists credentials on the DB' do
        expect do
          get_request
          admin.reload
        end.to change(admin, :confirmed_at).from(nil).and(
          change { admin.tokens.keys.count }.from(0).to(1)
        )

        expect(admin).to be_active_for_authentication
      end
    end
  end
end
