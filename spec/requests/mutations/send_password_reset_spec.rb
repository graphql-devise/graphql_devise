# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Send Password Reset Requests' do
  include_context 'with graphql query request'

  let!(:user)        { create(:user, :confirmed, email: 'jwinnfield@wallaceinc.com') }
  let(:email)        { user.email }
  let(:redirect_url) { 'https://google.com' }
  let(:query) do
    <<-GRAPHQL
      mutation {
        userSendPasswordReset(
          email:       "#{email}",
          redirectUrl: "#{redirect_url}"
        ) {
          message
        }
      }
    GRAPHQL
  end

  context 'when redirect_url is not whitelisted' do
    let(:redirect_url) { 'https://not-safe.com' }

    it 'returns a not whitelisted redirect url error' do
      expect { post_request }.to not_change(ActionMailer::Base.deliveries, :count)

      expect(json_response[:errors]).to containing_exactly(
        hash_including(
          message:    "Redirect to '#{redirect_url}' not allowed.",
          extensions: { code: 'USER_ERROR' }
        )
      )
    end
  end

  context 'when params are correct' do
    context 'when using the gem schema' do
      it 'sends password reset  email' do
        expect { post_request }.to change(ActionMailer::Base.deliveries, :count).by(1)

        expect(json_response[:data][:userSendPasswordReset]).to include(
          message: 'You will receive an email with instructions on how to reset your password in a few minutes.'
        )

        email = Nokogiri::HTML(ActionMailer::Base.deliveries.last.body.encoded)
        link  = email.css('a').first
        expect(link['href']).to include('/api/v1/graphql_auth?')

        expect do
          get link['href']
          user.reload
        end.to change(user, :allow_password_change).from(false).to(true)
      end
    end

    context 'when using a custom schema' do
      let(:custom_path) { '/api/v1/graphql' }

      it 'sends password reset  email' do
        expect { post_request(custom_path) }.to change(ActionMailer::Base.deliveries, :count).by(1)

        expect(json_response[:data][:userSendPasswordReset]).to include(
          message: 'You will receive an email with instructions on how to reset your password in a few minutes.'
        )

        email = Nokogiri::HTML(ActionMailer::Base.deliveries.last.body.encoded)
        link  = email.css('a').first
        expect(link['href']).to include("#{custom_path}?")

        expect do
          get link['href']
          user.reload
        end.to change(user, :allow_password_change).from(false).to(true)
      end
    end
  end

  context 'when email address uses different casing' do
    let(:email) { 'jWinnfield@wallaceinc.com' }

    it 'honors devise configuration for case insensitive fields' do
      expect { post_request }.to change(ActionMailer::Base.deliveries, :count).by(1)
      expect(json_response[:data][:userSendPasswordReset]).to include(
        message: 'You will receive an email with instructions on how to reset your password in a few minutes.'
      )
    end
  end

  context 'when user email is not found' do
    let(:email) { 'nothere@gmail.com' }

    before { post_request }

    it 'returns an error' do
      expect(json_response[:errors]).to contain_exactly(
        hash_including(message: 'User was not found or was not logged in.', extensions: { code: 'USER_ERROR' })
      )
    end
  end
end
