require 'rails_helper'

RSpec.describe 'Sign Up process' do
  include_context 'with graphql query request'

  let(:name)     { Faker::Name.name }
  let(:password) { Faker::Internet.password }
  let(:email)    { Faker::Internet.email }
  let(:redirect) { Faker::Internet.url }

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
            user {
              email
              name
            }
          }
        }
      GRAPHQL
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
          user: {
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
            authenticatable {
              email
            }
          }
        }
      GRAPHQL
    end

    it 'works without the confirmable module' do
      expect {
        post_request('/api/v1/guest/graphql_auth')
        pp json_response
      }.to change(Guest, :count).by(1)
    end
  end
end
