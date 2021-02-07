
require 'rails_helper'

RSpec.describe 'Sign Up process' do
  include_context 'with graphql schema test'

  let(:schema) { DummySchema }
  let(:user)   { create(:user, :confirmed) }

  describe 'publicField' do
    let(:query) do
      <<-GRAPHQL
        query {
          publicField
        }
      GRAPHQL
    end

    context 'when using a regular schema' do
      it 'does not require authentication' do
        expect(response[:data][:publicField]).to eq('Field does not require authentication')
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
      context 'when user is authenticated' do
        let(:resource) { user }

        it 'allows to perform the query' do
          expect(response[:data][:privateField]).to eq('Field will always require authentication')
        end

        context 'when using a SchemaUser' do
          let(:resource) { create(:schema_user, :confirmed) }

          it 'allows to perform the query' do
            expect(response[:data][:privateField]).to eq('Field will always require authentication')
          end
        end
      end

      context 'when user is not authenticated' do
        it 'returns a must sign in error' do
          expect(response[:errors]).to contain_exactly(
            hash_including(
              message:    'privateField field requires authentication',
              extensions: { code: 'AUTHENTICATION_ERROR' }
            )
          )
        end
      end
    end

    context 'when using an interpreter schema' do
      let(:schema) { InterpreterSchema }

      context 'when user is authenticated' do
        let(:resource) { user }

        it 'allows to perform the query' do
          expect(response[:data][:privateField]).to eq('Field will always require authentication')
        end
      end

      context 'when user is not authenticated' do
        it 'returns a must sign in error' do
          expect(response[:errors]).to contain_exactly(
            hash_including(
              message:    'privateField field requires authentication',
              extensions: { code: 'AUTHENTICATION_ERROR' }
            )
          )
        end
      end
    end
  end

  describe 'user' do
    let(:query) do
      <<-GRAPHQL
        query {
          user(id: #{user.id}) {
            id
            email
          }
        }
      GRAPHQL
    end

    context 'when using a regular schema' do
      context 'when user is authenticated' do
        let(:resource) { user }

        it 'allows to perform the query' do
          expect(response[:data][:user]).to match(
            email: user.email,
            id:    user.id
          )
        end
      end

      context 'when user is not authenticated' do
        it 'returns a must sign in error' do
          expect(response[:errors]).to contain_exactly(
            hash_including(
              message: 'user field requires authentication',
              extensions: { code: 'AUTHENTICATION_ERROR' }
            )
          )
        end
      end
    end

    context 'when using an interpreter schema' do
      let(:schema) { InterpreterSchema }

      context 'when user is authenticated' do
        let(:resource) { user }

        it 'allows to perform the query' do
          expect(response[:data][:user]).to match(
            email: user.email,
            id:    user.id
          )
        end
      end

      context 'when user is not authenticated' do
        # Interpreter schema fields are public unless specified otherwise (plugin setting)
        it 'allows to perform the query' do
          expect(response[:data][:user]).to match(
            email: user.email,
            id:    user.id
          )
        end
      end
    end
  end
end
