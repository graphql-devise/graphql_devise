require 'rails_helper'

RSpec.describe 'Send Password Reset Requests' do
  include_context 'with graphql query request'

  let!(:user)        { create(:user, :confirmed, email: 'jwinnfield@wallaceinc.com') }
  let(:email)        { user.email }
  let(:redirect_url) { Faker::Internet.url }
  let(:query) do
    <<-GRAPHQL
      mutation {
        userSendPasswordReset(
          email:       "#{email}",
          redirectUrl: "#{redirect_url}"
        ) {
          authenticatable {
            email
          }
        }
      }
    GRAPHQL
  end

  context 'when params are correct' do
    it 'sends password reset  email' do
      expect { post_request }.to change(ActionMailer::Base.deliveries, :count).by(1)

      email = Nokogiri::HTML(ActionMailer::Base.deliveries.last.body.encoded)
      link  = email.css('a').first

      # TODO: Move to feature spec
      expect do
        get link['href']
        user.reload
      end.to change(user, :allow_password_change).from(false).to(true)
    end
  end

  context 'when email address uses different casing' do
    let(:email) { 'jWinnfield@wallaceinc.com' }

    it 'honors devise configuration for case insensitive fields' do
      expect { post_request }.to change(ActionMailer::Base.deliveries, :count).by(1)
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
