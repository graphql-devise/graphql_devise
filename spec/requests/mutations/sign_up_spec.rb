require 'rails_helper'

RSpec.describe '' do
  include_context 'with graphql query request'

  let(:name)     { Faker::Name.name }
  let(:password) { Faker::Internet.password }
  let(:email)    { Faker::Internet.email }
  let(:redirect) { Faker::Internet.url }
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
          success
          errors
          user {
            email
            name
          }
        }
      }
    GRAPHQL
  end

  it 'creates a new resource that requires confirmation' do
    expect {
      post '/api/v1/graphql_auth', *graphql_params
      json_response
    }.to(
      change(User, :count).by(1)
      .and(change(ActionMailer::Base.deliveries, :count).by(1))
    )

    user = User.last
    expect(user).not_to be_active_for_authentication
    expect(user.confirmed_at).to be_nil
    expect(user.valid_password?(password)).to be_truthy
    expect(json_response[:data][:userSignUp]).to include(
      success: true,
      errors: [],
      user: {
        email: email,
        name: name
      }
    )

    email = ActionMailer::Base.deliveries.last
    query = ERB::Util.url_encode("confirmAccount($token:ID!,$clientConfig:String,redirect:String!){userConfirmAccount(token:$token,clientConfig:$clientConfig,redirect:$redirect){success,errors}}&variables={token:\"#{user.confirmation_token}\",clientConfig:\"default\",redirect:\"#{redirect}\"}").html_safe
    expect(email.body.encoded).to match(/query="#{query}"/)
  end
end
