# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Additional Mutations' do
  include_context 'with graphql query request'

  let(:name)                  { Faker::Name.name }
  let(:password)              { Faker::Internet.password }
  let(:password_confirmation) { password }
  let(:email)                 { Faker::Internet.email }

  context 'when using the user model' do
    let(:query) do
      <<-GRAPHQL
        mutation {
          registerConfirmedUser(
            email:                "#{email}",
            name:                 "#{name}",
            password:             "#{password}",
            passwordConfirmation: "#{password_confirmation}"
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
      it 'creates a new resource that is already confirmed' do
        expect { post_request }.to(
          change(User, :count).by(1)
          .and(not_change(ActionMailer::Base.deliveries, :count))
        )

        user = User.last

        expect(user).to be_confirmed
        expect(json_response[:data][:registerConfirmedUser]).to include(
          user: {
            email: email,
            name:  name
          }
        )
      end
    end

    context 'when params are incorrect' do
      let(:password_confirmation) { 'not the same' }

      it 'returns descriptive errors' do
        expect { post_request }.to not_change(User, :count)

        expect(json_response[:errors]).to contain_exactly(
          hash_including(
            message:    'Custom registration failed',
            extensions: { code: 'USER_ERROR', detailed_errors: ["Password confirmation doesn't match Password"] }
          )
        )
      end
    end
  end
end
