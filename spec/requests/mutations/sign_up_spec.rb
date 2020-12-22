# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sign Up process' do
  include_context 'with graphql query request'

  let(:name)     { Faker::Name.name }
  let(:password) { Faker::Internet.password }
  let(:email)    { Faker::Internet.email }
  let(:redirect) { 'https://google.com' }

  context 'when using the user model' do
    let(:query) do
      <<-GRAPHQL
        mutation {
          userSignUp(
            email:                "#{email}"
            name:                 "#{name}"
            password:             "#{password}"
            passwordConfirmation: "#{password}"
            confirmSuccessUrl:    "#{redirect}"
          ) {
            credentials { accessToken }
            user {
              email
              name
            }
          }
        }
      GRAPHQL
    end

    context 'when redirect_url is not whitelisted' do
      let(:redirect) { 'https://not-safe.com' }

      it 'returns a not whitelisted redirect url error' do
        expect { post_request }.to(
          not_change(User, :count)
          .and(not_change(ActionMailer::Base.deliveries, :count))
        )

        expect(json_response[:errors]).to containing_exactly(
          hash_including(
            message:    "Redirect to '#{redirect}' not allowed.",
            extensions: { code: 'USER_ERROR' }
          )
        )
      end
    end

    context 'when params are correct' do
      it 'creates a new resource that requires confirmation' do
        expect { post_request }.to(
          change(User, :count).by(1)
          .and(change(ActionMailer::Base.deliveries, :count).by(1))
        )

        user = User.last

        expect(user).not_to be_active_for_authentication
        expect(user.confirmed_at).to be_nil
        expect(user).to be_valid_password(password)
        expect(json_response[:data][:userSignUp]).to include(
          credentials: nil,
          user:        {
            email: email,
            name:  name
          }
        )

        email = Nokogiri::HTML(ActionMailer::Base.deliveries.last.body.encoded)
        link  = email.css('a').first

        expect do
          get link['href']
          user.reload
        end.to change { user.active_for_authentication? }.to(true)
      end

      context 'when email address uses different casing' do
        let(:email) { 'miaWallace@wallaceinc.com' }

        it 'honors devise configuration for case insensitive fields' do
          expect { post_request }.to change(ActionMailer::Base.deliveries, :count).by(1)
          expect(User.last.email).to eq('miawallace@wallaceinc.com')
          expect(json_response[:data][:userSignUp]).to include(user: { email: 'miawallace@wallaceinc.com', name: name })
        end
      end
    end

    context 'when required params are missing' do
      let(:email) { '' }

      it 'does *NOT* create resource a resource nor send an email' do
        expect { post_request }.to(
          not_change(User, :count)
          .and(not_change(ActionMailer::Base.deliveries, :count))
        )

        expect(json_response[:data][:userSignUp]).to be_nil
        expect(json_response[:errors]).to containing_exactly(
          hash_including(
            message:    "User couldn't be registered",
            extensions: { code: 'USER_ERROR', detailed_errors: ["Email can't be blank"] }
          )
        )
      end
    end
  end

  context 'when using the admin model' do
    let(:query) do
      <<-GRAPHQL
        mutation {
          adminSignUp(
            email:                "#{email}"
            password:             "#{password}"
            passwordConfirmation: "#{password}"
            confirmSuccessUrl:    "#{redirect}"
          ) {
            authenticatable {
              email
            }
          }
        }
      GRAPHQL
    end

    before { post_request }

    it 'skips the sign up mutation' do
      expect(json_response[:errors]).to contain_exactly(
        hash_including(message: "Field 'adminSignUp' doesn't exist on type 'Mutation'")
      )
    end
  end

  context 'when using the guest model' do
    let(:query) do
      <<-GRAPHQL
        mutation {
          guestSignUp(
            email:                "#{email}"
            password:             "#{password}"
            passwordConfirmation: "#{password}"
            confirmSuccessUrl:    "#{redirect}"
          ) {
            credentials { accessToken client uid }
            authenticatable {
              email
            }
          }
        }
      GRAPHQL
    end

    it 'returns credentials as no confirmation is required' do
      expect { post_request }.to change(Guest, :count).from(0).to(1)

      expect(json_response[:data][:guestSignUp]).to include(
        authenticatable: { email: email },
        credentials:     hash_including(
          uid:    email,
          client: Guest.last.tokens.keys.first
        )
      )
    end
  end
end
