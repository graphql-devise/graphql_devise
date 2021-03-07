# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Login Requests' do
  include_context 'with graphql query request'

  let(:query) do
    <<-GRAPHQL
      query IntrospectionQuery {
        __schema {
          queryType { name }
          mutationType { name }
          subscriptionType { name }
          types {
            ...FullType
          }
          directives {
            name
            description
            args {
              ...InputValue
            }
            onOperation
            onFragment
            onField
          }
        }
      }

      fragment FullType on __Type {
        kind
        name
        description
        fields(includeDeprecated: true) {
          name
          description
          args {
            ...InputValue
          }
          type {
            ...TypeRef
          }
          isDeprecated
          deprecationReason
        }
        inputFields {
          ...InputValue
        }
        interfaces {
          ...TypeRef
        }
        enumValues(includeDeprecated: true) {
          name
          description
          isDeprecated
          deprecationReason
        }
        possibleTypes {
          ...TypeRef
        }
      }

      fragment InputValue on __InputValue {
        name
        description
        type { ...TypeRef }
        defaultValue
      }

      fragment TypeRef on __Type {
        kind
        name
        ofType {
          kind
          name
          ofType {
            kind
            name
            ofType {
              kind
              name
            }
          }
        }
      }

    GRAPHQL
  end

  context 'when using a schema plugin to mount devise operations' do
    context 'when schema plugin is set to authenticate by default' do
      context 'when the resource is authenticated' do
        let(:user) { create(:user, :confirmed) }
        let(:headers) { user.create_new_auth_token }

        it 'return the schema information' do
          post_request('/api/v1/graphql')

          expect(json_response[:data][:__schema].keys).to contain_exactly(
            :queryType, :mutationType, :subscriptionType, :types, :directives
          )
        end
      end

      context 'when the resource is *NOT* authenticated' do
        context 'and instrospection is set to be public' do
          it 'return the schema information' do
            post_request('/api/v1/graphql')

            expect(json_response[:data][:__schema].keys).to contain_exactly(
              :queryType, :mutationType, :subscriptionType, :types, :directives
            )
          end
        end

        context 'and introspection is set to require auth' do
          before do
            allow_any_instance_of(GraphqlDevise::SchemaPlugin).to(
              receive(:public_introspection).and_return(false)
            )
          end

          it 'return an error' do
            post_request('/api/v1/graphql')

            expect(json_response[:data]).to be_nil
            expect(json_response[:errors]).to contain_exactly(
              hash_including(
                message:    '__schema field requires authentication',
                extensions: { code: 'AUTHENTICATION_ERROR' }
              )
            )
          end
        end
      end
    end

    context 'when schema plugin is set *NOT* to authenticate by default' do
      it 'return the schema information' do
        post_request('/api/v1/interpreter')

        expect(json_response[:data][:__schema].keys).to contain_exactly(
          :queryType, :mutationType, :subscriptionType, :types, :directives
        )
      end
    end
  end
end
