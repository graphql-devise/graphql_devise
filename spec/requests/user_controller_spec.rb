# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Integrations with the user's controller" do
  include_context 'with graphql query request'

  shared_examples 'returns a must authenticate error' do |field|
    it 'returns a must sign in error' do
      expect(json_response[:errors]).to contain_exactly(
        hash_including(message: "#{field} field requires authentication", extensions: { code: 'AUTHENTICATION_ERROR' })
      )
    end
  end

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
  end

  describe 'privateField' do
    let(:query) do
      <<-GRAPHQL
        query {
          privateField
        }
      GRAPHQL
    end

    context 'when authenticating before using the GQL schema' do
      before { post_request('/api/v1/controller_auth') }

      context 'when user is authenticated' do
        let(:headers) { create(:schema_user).create_new_auth_token }

        it 'allows authentication at the controller level' do
          expect(json_response[:data][:privateField]).to eq('Field will always require authentication')
        end
      end

      context 'when user is not authenticated' do
        it_behaves_like 'returns a must authenticate error', 'privateField'
      end
    end

    context 'when using a regular schema' do
      before { post_request('/api/v1/graphql') }

      context 'when user is authenticated' do
        let(:headers) { user.create_new_auth_token }

        it 'allows to perform the query' do
          expect(json_response[:data][:privateField]).to eq('Field will always require authentication')
        end

        context 'when using a SchemaUser' do
          let(:headers) { create(:schema_user, :confirmed).create_new_auth_token }

          it 'allows to perform the query' do
            expect(json_response[:data][:privateField]).to eq('Field will always require authentication')
          end
        end
      end

      context 'when user is not authenticated' do
        it_behaves_like 'returns a must authenticate error', 'privateField'
      end

      context 'when using the failing route' do
        it 'raises an invalid resource_name error' do
          expect { post_request('/api/v1/failing') }.to raise_error(
            GraphqlDevise::Error,
            'Invalid resource_name `fail` provided to `graphql_context`. Possible values are: [:user, :admin, :guest, :users_customer, :schema_user].'
          )
        end
      end
    end

    context 'when using an interpreter schema' do
      before { post_request('/api/v1/interpreter') }

      context 'when user is authenticated' do
        let(:headers) { user.create_new_auth_token }

        it 'allows to perform the query' do
          expect(json_response[:data][:privateField]).to eq('Field will always require authentication')
        end
      end

      context 'when user is not authenticated' do
        it_behaves_like 'returns a must authenticate error', 'privateField'
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

        it 'allows to perform the query' do
          expect(json_response[:data][:dummyMutation]).to eq('Necessary so GraphQL gem does not complain about empty mutation type')
        end
      end

      context 'when user is not authenticated' do
        it_behaves_like 'returns a must authenticate error', 'dummyMutation'
      end
    end

    context 'when using an interpreter schema' do
      before { post_request('/api/v1/interpreter') }

      context 'when user is authenticated' do
        let(:headers) { user.create_new_auth_token }

        it 'allows to perform the query' do
          expect(json_response[:data][:dummyMutation]).to eq('Necessary so GraphQL gem does not complain about empty mutation type')
        end
      end

      context 'when user is not authenticated' do
        it_behaves_like 'returns a must authenticate error', 'dummyMutation'
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

        it 'allows to perform the query' do
          expect(json_response[:data][:user]).to match(
            email: user.email,
            id:    user.id
          )
        end
      end

      context 'when user is not authenticated' do
        it_behaves_like 'returns a must authenticate error', 'user'
      end
    end

    context 'when using an interpreter schema' do
      before { post_request('/api/v1/interpreter') }

      context 'when user is authenticated' do
        let(:headers) { user.create_new_auth_token }

        it 'allows to perform the query' do
          expect(json_response[:data][:user]).to match(
            email: user.email,
            id:    user.id
          )
        end
      end

      context 'when user is not authenticated' do
        # Interpreter schema fields are public unless specified otherwise (plugin setting)
        it 'allows to perform the query' do
          expect(json_response[:data][:user]).to match(
            email: user.email,
            id:    user.id
          )
        end
      end
    end
  end

  describe 'updateUser' do
    let(:headers) { user.create_new_auth_token }
    let(:query) do
      <<-GRAPHQL
        mutation {
          updateUser(email: "updated@gmail.com", name: "updated name") {
            user { email name }
          }
        }
      GRAPHQL
    end

    it 'requires new email confirmation' do
      original_email = user.email

      expect do
        post_request('/api/v1/graphql?test=value')
        user.reload
      end.to not_change(user, :email).from(original_email).and(
        change(user, :unconfirmed_email).from(nil).to('updated@gmail.com')
      ).and(
        not_change(user, :uid).from(original_email)
      ).and(
        change(user, :name).from(user.name).to('updated name')
      )

      email = Nokogiri::HTML(ActionMailer::Base.deliveries.last.body.encoded)
      link  = email.css('a').first
      expect(link['href']).to include('/api/v1/graphql')

      expect do
        get link['href']
        user.reload
      end.to change(user, :email).from(original_email).to('updated@gmail.com').and(
        change(user, :uid).from(original_email).to('updated@gmail.com')
      )
    end
  end

  describe 'vipField' do
    let(:error_message) { 'Field available only for VIP Users' }
    let(:query) do
      <<-GRAPHQL
        query { vipField }
      GRAPHQL
    end

    context 'when using a regular schema' do
      before { post_request('/api/v1/graphql') }

      context 'when user is authenticated' do
        let(:headers) { user.create_new_auth_token }

        context 'when schema user is VIP' do
          let(:user) { create(:user, :confirmed, vip: true) }

          it 'allows to perform the query' do
            expect(json_response[:data][:vipField]).to eq(error_message)
          end
        end

        context 'when schema user is not VIP' do
          it_behaves_like 'returns a must authenticate error', 'vipField'
        end
      end

      context 'when user is not authenticated' do
        it_behaves_like 'returns a must authenticate error', 'vipField'
      end
    end

    context 'when using the interpreter schema' do
      before { post_request('/api/v1/interpreter') }

      context 'when user is authenticated' do
        let(:headers) { user.create_new_auth_token }

        context 'when schema user is VIP' do
          let(:user) { create(:user, :confirmed, vip: true) }

          it 'allows to perform the query' do
            expect(json_response[:data][:vipField]).to eq(error_message)
          end
        end

        context 'when schema user is not VIP' do
          it_behaves_like 'returns a must authenticate error', 'vipField'
        end
      end

      context 'when user is not authenticated' do
        it_behaves_like 'returns a must authenticate error', 'vipField'
      end
    end
  end
end
