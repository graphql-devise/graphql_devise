# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Resend confirmation' do
  include_context 'with graphql query request'

  let(:confirmed_at) { nil }
  let!(:user)        { create(:user, confirmed_at: nil, email: 'mwallace@wallaceinc.com') }
  let(:email)        { user.email }
  let(:id)           { user.id }
  let(:redirect)     { 'https://google.com' }
  let(:query) do
    <<-GRAPHQL
      mutation {
        userResendConfirmation(
          email:"#{email}",
          redirectUrl:"#{redirect}"
        ) {
          message
        }
      }
    GRAPHQL
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

  context 'when params are correct' do
    context 'when using the gem schema' do
      it 'sends an email to the user with confirmation url and returns a success message' do
        expect { post_request }.to change(ActionMailer::Base.deliveries, :count).by(1)
        expect(json_response[:data][:userResendConfirmation]).to include(
          message: 'You will receive an email with instructions for how to confirm your email address in a few minutes.'
        )

        email = Nokogiri::HTML(ActionMailer::Base.deliveries.last.body.encoded)
        link  = email.css('a').first
        confirm_link_msg_text = email.css('p')[1].inner_html
        confirm_account_link_text = link.inner_html

        expect(link['href']).to include('/api/v1/graphql_auth?')
        expect(confirm_link_msg_text).to eq('You can confirm your account email through the link below:')
        expect(confirm_account_link_text).to eq('Confirm my account')

        expect do
          get link['href']
          user.reload
        end.to change(user, :confirmed_at).from(NilClass).to(ActiveSupport::TimeWithZone)
      end
    end

    context 'when using a custom schema' do
      let(:custom_path) { '/api/v1/graphql' }

      it 'sends an email to the user with confirmation url and returns a success message' do
        expect { post_request(custom_path) }.to change(ActionMailer::Base.deliveries, :count).by(1)
        expect(json_response[:data][:userResendConfirmation]).to include(
          message: 'You will receive an email with instructions for how to confirm your email address in a few minutes.'
        )

        email = Nokogiri::HTML(ActionMailer::Base.deliveries.last.body.encoded)
        link  = email.css('a').first
        confirm_link_msg_text = email.css('p')[1].inner_html
        confirm_account_link_text = link.inner_html

        expect(link['href']).to include("#{custom_path}?")
        expect(confirm_link_msg_text).to eq('You can confirm your account email through the link below:')
        expect(confirm_account_link_text).to eq('Confirm my account')

        expect do
          get link['href']
          user.reload
        end.to change(user, :confirmed_at).from(NilClass).to(ActiveSupport::TimeWithZone)
      end
    end

    context 'when email address uses different casing' do
      let(:email) { 'mWallace@wallaceinc.com' }

      it 'honors devise configuration for case insensitive fields' do
        expect { post_request }.to change(ActionMailer::Base.deliveries, :count).by(1)
        expect(json_response[:data][:userResendConfirmation]).to include(
          message: 'You will receive an email with instructions for how to confirm your email address in a few minutes.'
        )
      end
    end

    context 'when the user has already been confirmed' do
      before { user.confirm }

      it 'does *NOT* send an email and raises an error' do
        expect { post_request }.to not_change(ActionMailer::Base.deliveries, :count)
        expect(json_response[:data][:userResendConfirmation]).to be_nil
        expect(json_response[:errors]).to contain_exactly(
          hash_including(
            message:    'Email was already confirmed, please try signing in',
            extensions: { code: 'USER_ERROR' }
          )
        )
      end
    end
  end

  context 'when the email was changed' do
    let(:confirmed_at) { 2.seconds.ago }
    let(:email)        { 'new-email@wallaceinc.com' }
    let(:new_email)    { email }

    before do
      user.update_with_email(
        email:                    new_email,
        schema_url:               'http://localhost/test',
        confirmation_success_url: 'https://google.com'
      )
    end

    it 'sends new confirmation email' do
      expect { post_request }.to change(ActionMailer::Base.deliveries, :count).by(1)
      expect(ActionMailer::Base.deliveries.first.to).to contain_exactly(new_email)
      expect(json_response[:data][:userResendConfirmation]).to include(
        message: 'You will receive an email with instructions for how to confirm your email address in a few minutes.'
      )
    end
  end

  context "when the email isn't in the system" do
    let(:email) { 'nothere@gmail.com' }

    it 'does *NOT* send an email and raises an error' do
      expect { post_request }.to not_change(ActionMailer::Base.deliveries, :count)
      expect(json_response[:data][:userResendConfirmation]).to be_nil
      expect(json_response[:errors]).to contain_exactly(
        hash_including(
          message:    "Unable to find user with email '#{email}'.",
          extensions: { code: 'USER_ERROR' }
        )
      )
    end
  end
end
