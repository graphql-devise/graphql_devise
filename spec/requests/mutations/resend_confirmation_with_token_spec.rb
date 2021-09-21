# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Resend confirmation with token' do
  include_context 'with graphql query request'

  let(:confirmed_at) { nil }
  let!(:user)        { create(:user, confirmed_at: nil, email: 'mwallace@wallaceinc.com') }
  let(:email)        { user.email }
  let(:id)           { user.id }
  let(:confirm_url)  { 'https://google.com' }
  let(:query) do
    <<-GRAPHQL
      mutation {
        userResendConfirmationWithToken(
          email:"#{email}",
          confirmUrl:"#{confirm_url}"
        ) {
          message
        }
      }
    GRAPHQL
  end

  context 'when confirm_url is not whitelisted' do
    let(:confirm_url) { 'https://not-safe.com' }

    it 'returns a not whitelisted confirm url error' do
      expect { post_request }.to not_change(ActionMailer::Base.deliveries, :count)

      expect(json_response[:errors]).to containing_exactly(
        hash_including(
          message:    "Redirect to '#{confirm_url}' not allowed.",
          extensions: { code: 'USER_ERROR' }
        )
      )
    end
  end

  context 'when params are correct' do
    context 'when using the gem schema' do
      it 'sends an email to the user with confirmation url and returns a success message' do
        expect { post_request }.to change(ActionMailer::Base.deliveries, :count).by(1)
        expect(json_response[:data][:userResendConfirmationWithToken]).to include(
          message: 'You will receive an email with instructions for how to confirm your email address in a few minutes.'
        )

        email         = Nokogiri::HTML(ActionMailer::Base.deliveries.last.body.encoded)
        confirm_link  = email.css('a').first['href']
        confirm_token = confirm_link.match(/\?confirmationToken\=(?<token>.+)\z/)[:token]

        expect(User.confirm_by_token(confirm_token)).to eq(user)
      end
    end

    context 'when using a custom schema' do
      let(:custom_path) { '/api/v1/graphql' }

      it 'sends an email to the user with confirmation url and returns a success message' do
        expect { post_request(custom_path) }.to change(ActionMailer::Base.deliveries, :count).by(1)
        expect(json_response[:data][:userResendConfirmationWithToken]).to include(
          message: 'You will receive an email with instructions for how to confirm your email address in a few minutes.'
        )

        email         = Nokogiri::HTML(ActionMailer::Base.deliveries.last.body.encoded)
        confirm_link  = email.css('a').first['href']
        confirm_token = confirm_link.match(/\?confirmationToken\=(?<token>.+)\z/)[:token]

        expect(User.confirm_by_token(confirm_token)).to eq(user)
      end
    end

    context 'when email address uses different casing' do
      let(:email) { 'mWallace@wallaceinc.com' }

      it 'honors devise configuration for case insensitive fields' do
        expect { post_request }.to change(ActionMailer::Base.deliveries, :count).by(1)
        expect(json_response[:data][:userResendConfirmationWithToken]).to include(
          message: 'You will receive an email with instructions for how to confirm your email address in a few minutes.'
        )
      end
    end

    context 'when the user has already been confirmed' do
      before { user.confirm }

      it 'does *NOT* send an email and raises an error' do
        expect { post_request }.to not_change(ActionMailer::Base.deliveries, :count)
        expect(json_response[:data][:userResendConfirmationWithToken]).to be_nil
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
        email:            new_email,
        confirmation_url: 'https://google.com'
      )
    end

    it 'sends new confirmation email' do
      expect { post_request }.to change(ActionMailer::Base.deliveries, :count).by(1)
      expect(ActionMailer::Base.deliveries.first.to).to contain_exactly(new_email)
      expect(json_response[:data][:userResendConfirmationWithToken]).to include(
        message: 'You will receive an email with instructions for how to confirm your email address in a few minutes.'
      )
    end
  end

  context "when the email isn't in the system" do
    let(:email) { 'notthere@gmail.com' }

    it 'does *NOT* send an email and raises an error' do
      expect { post_request }.to not_change(ActionMailer::Base.deliveries, :count)
      expect(json_response[:data][:userResendConfirmationWithToken]).to be_nil
      expect(json_response[:errors]).to contain_exactly(
        hash_including(
          message:    "Unable to find user with email '#{email}'.",
          extensions: { code: 'USER_ERROR' }
        )
      )
    end
  end
end
