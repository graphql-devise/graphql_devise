require 'rails_helper'

RSpec.describe 'Resend confirmation' do
  include_context 'with graphql query request'

  let(:user)     { create(:user, confirmed_at: nil) }
  let(:email)    { user.email }
  let(:redirect) { Faker::Internet.url }
  let(:query) do
    <<-GRAPHQL
      mutation {
        userResendConfirmation(
          email:"#{email}",
          redirectUrl:"#{redirect}"
        ) {
          message
          success
        }
      }
    GRAPHQL
  end

  context 'when params are correct' do
    it 'sends an email to the user with confirm url' do
      expect { post_request }.to(
        change(ActionMailer::Base.deliveries, :count).by(1)
      )

      email = Nokogiri::HTML(ActionMailer::Base.deliveries.last.body.encoded)
      link  = email.css('a').first

      # TODO: Move to feature spec
      expect do
        get link['href']
        user.reload
      end.to change(user, :confirmed_at).from(NilClass).to(Time)
    end
  end

  context 'when the email isn''t in the system' do
    let(:email) { 'nothere@gmail.com' }
    before { post_request }

    it 'returns an error' do
      expect(json_response[:errors]).to contain_exactly(
        hash_including(
          message: "Unable to find user with email '#{email}'.", extensions: { code: 'USER_ERROR' })
      )
    end
  end
end