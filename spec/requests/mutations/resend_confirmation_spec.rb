require 'rails_helper'

RSpec.describe 'Resend confirmation' do
  include_context 'with graphql query request'

  let(:user)     { create(:user, confirmed_at: nil) }
  let(:email)    { user.email }
  let(:id)       { user.id }
  let(:redirect) { Faker::Internet.url }
  let(:query) do
    <<-GRAPHQL
      mutation {
        userResendConfirmation(
          email:"#{email}",
          redirectUrl:"#{redirect}"
        ) {
          message
          authenticable {
            id
            email
          }
        }
      }
    GRAPHQL
  end

  context 'when params are correct' do
    it 'sends an email to the user with confirmation url and returns a success message' do
      expect { post_request }.to change(ActionMailer::Base.deliveries, :count).by 1
      expect(json_response[:data][:userResendConfirmation]).to include(
        authenticable: {
          id: id,
          email: email
        },
        message: "You will receive an email with instructions for how to confirm your email address in a few minutes."
      )
      
      email = Nokogiri::HTML(ActionMailer::Base.deliveries.last.body.encoded)
      link  = email.css('a').first
      confirm_link_msg_text = email.css('p')[1].inner_html
      confirm_account_link_text = link.inner_html

      expect(confirm_link_msg_text).to eq("You can confirm your account email through the link below:")
      expect(confirm_account_link_text).to eq("Confirm my account")

      # TODO: Move to feature spec
      expect do
        get link['href']
        user.reload
      end.to change(user, :confirmed_at).from(NilClass).to(ActiveSupport::TimeWithZone)
    end

    context 'when the user has already been confirmed' do
      before { user.confirm }

      it 'does *NOT* send an email and raises an error' do
        expect { post_request }.to change(ActionMailer::Base.deliveries, :count).by 0
        expect(json_response[:data][:userResendConfirmation]).to be_nil
        expect(json_response[:errors]).to contain_exactly(
          hash_including(
            message: "Email was already confirmed, please try signing in",
            extensions: { code: 'USER_ERROR' }
          )
        )
      end
    end
  end

  context "when the email isn't in the system" do
    let(:email) { 'nothere@gmail.com' }

    it 'does *NOT* send an email and raises an error' do
      expect { post_request }.to not_change(ActionMailer::Base.deliveries, :count)
      expect(json_response[:data][:userResendConfirmation]).to be_nil
      expect(json_response[:errors]).to contain_exactly(
        hash_including(
          message: "Unable to find user with email '#{email}'.",
          extensions: { code: 'USER_ERROR' }
        )
      )
    end
  end
end
