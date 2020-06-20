require 'rails_helper'
require 'devise/version'

RSpec.describe "Integrations with the user's controller" do
  include_context 'with graphql query request'

  let(:user) { create(:user, :confirmed) }

  describe 'publicField' do
    let(:query) do
      <<-GRAPHQL
        query {
          publicField
        }
      GRAPHQL
    end

    context 'when using a regular schema' do
      before { post_request('/api/v1/graphql') }

      it 'does not require authentication' do
        expect(json_response[:data][:publicField]).to eq('Field does not require authentication')
      end
    end

    context 'when using an interpreter schema' do
      before { post_request('/api/v1/interpreter') }

      it 'does not require authentication' do
        expect(json_response[:data][:publicField]).to eq('Field does not require authentication')
      end
    end

    context 'when using the failing route' do
      it 'raises an invalid resource_name error' do
        expect { post_request('/api/v1/failing') }.to raise_error(
          GraphqlDevise::Error,
          'Invalid resource_name `fail` provided to `graphql_context`. Possible values are: [:user, :admin, :guest, :users_customer].'
        )
      end
    end
  end

  describe 'privateField' do
    let(:query) do
      <<-GRAPHQL
        query {
          privateField
        }
      GRAPHQL
    end

    context 'when using a regular schema' do
      before { post_request('/api/v1/graphql') }

      context 'when user is authenticated' do
        let(:headers) { user.create_new_auth_token }

        it 'allow to perform the query' do
          expect(json_response[:data][:privateField]).to eq('Field will always require authentication')
        end
      end

      context 'when user is not authenticated' do
        it 'returns a must sign in error' do
          expect(json_response[:errors]).to contain_exactly(
            hash_including(message: 'privateField field requires authentication', extensions: { code: 'AUTHENTICATION_ERROR' })
          )
        end
      end
    end

    context 'when using an interpreter schema' do
      before { post_request('/api/v1/interpreter') }

      context 'when user is authenticated' do
        let(:headers) { user.create_new_auth_token }

        it 'allow to perform the query' do
          expect(json_response[:data][:privateField]).to eq('Field will always require authentication')
        end
      end

      context 'when user is not authenticated' do
        it 'returns a must sign in error' do
          expect(json_response[:errors]).to contain_exactly(
            hash_including(message: 'privateField field requires authentication', extensions: { code: 'AUTHENTICATION_ERROR' })
          )
        end
      end
    end
  end

  describe 'dummyMutation' do
    let(:query) do
      <<-GRAPHQL
        mutation {
          dummyMutation
        }
      GRAPHQL
    end

    context 'when using a regular schema' do
      before { post_request('/api/v1/graphql') }

      context 'when user is authenticated' do
        let(:headers) { user.create_new_auth_token }

        it 'allow to perform the query' do
          expect(json_response[:data][:dummyMutation]).to eq('Necessary so GraphQL gem does not complain about empty mutation type')
        end
      end

      context 'when user is not authenticated' do
        it 'returns a must sign in error' do
          expect(json_response[:errors]).to contain_exactly(
            hash_including(message: 'dummyMutation field requires authentication', extensions: { code: 'AUTHENTICATION_ERROR' })
          )
        end
      end
    end

    context 'when using an interpreter schema' do
      before { post_request('/api/v1/interpreter') }

      context 'when user is authenticated' do
        let(:headers) { user.create_new_auth_token }

        it 'allow to perform the query' do
          expect(json_response[:data][:dummyMutation]).to eq('Necessary so GraphQL gem does not complain about empty mutation type')
        end
      end

      context 'when user is not authenticated' do
        it 'returns a must sign in error' do
          expect(json_response[:errors]).to contain_exactly(
            hash_including(message: 'dummyMutation field requires authentication', extensions: { code: 'AUTHENTICATION_ERROR' })
          )
        end
      end
    end
  end

  describe 'user' do
    let(:query) do
      <<-GRAPHQL
        query {
          user(
            id: #{user.id}
          ) {
            id
            email
          }
        }
      GRAPHQL
    end

    context 'when using a regular schema' do
      before { post_request('/api/v1/graphql') }

      context 'when user is authenticated' do
        let(:headers) { user.create_new_auth_token }

        it 'allow to perform the query' do
          expect(json_response[:data][:user]).to match(
            email: user.email,
            id:    user.id
          )
        end
      end

      context 'when user is not authenticated' do
        it 'returns a must sign in error' do
          expect(json_response[:errors]).to contain_exactly(
            hash_including(message: 'user field requires authentication', extensions: { code: 'AUTHENTICATION_ERROR' })
          )
        end
      end
    end

    context 'when using an interpreter schema' do
      before { post_request('/api/v1/interpreter') }

      context 'when user is authenticated' do
        let(:headers) { user.create_new_auth_token }

        it 'allow to perform the query' do
          expect(json_response[:data][:user]).to match(
            email: user.email,
            id:    user.id
          )
        end
      end

      context 'when user is not authenticated' do
        # Interpreter schema fields are public unless specified otherwise (plugin setting)
        it 'allow to perform the query' do
          expect(json_response[:data][:user]).to match(
            email: user.email,
            id:    user.id
          )
        end
      end
    end
  end

  describe 'updateUserEmail' do
    let(:headers) { user.create_new_auth_token }
    let(:query) do
      <<-GRAPHQL
        mutation {
          updateUserEmail(email: "updated@gmail.com") {
            user { email }
          }
        }
      GRAPHQL
    end

    before do
      unless Gem::Version.new(DeviseTokenAuth::VERSION) >= Gem::Version.new('1.1.4') && Gem::Version.new(Devise::VERSION) != Gem::Version.new('4.7.2')
        skip 'Reconfirmable fixed in DTA >= 1.1.4'
      end
    end

    it 'requires new email confirmation' do
      original_email = user.email

      expect do
        post_request('/api/v1/graphql')
        user.reload
      end.to not_change(user, :email).from(original_email).and(
        change(user, :unconfirmed_email).from(nil).to('updated@gmail.com')
      )

      email = Nokogiri::HTML(ActionMailer::Base.deliveries.last.body.encoded)
      link  = email.css('a').first
      expect(link['href']).to include('/api/v1/graphql')

      expect do
        get link['href']
        user.reload
      end.to change(user, :email).from(original_email).to('updated@gmail.com')
    end

    it 'raises an error when default_confirm_url is not set' do
      original_default = DeviseTokenAuth.default_confirm_success_url
      DeviseTokenAuth.default_confirm_success_url = nil

      expect { post_request('/api/v1/graphql') }.to raise_error(
        GraphqlDevise::Error,
        'You must set `default_confirm_success_url` on the DeviseTokenAuth initializer for reconfirmable to work.'
      )

      DeviseTokenAuth.default_confirm_success_url = original_default
    end
  end
end
