# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users controller specs' do
  include_context 'with graphql schema test'

  let(:schema)          { DummySchema }
  let(:user)            { create(:user, :confirmed) }
  let(:field)           { 'privateField' }
  let(:public_message)  { 'Field does not require authentication' }
  let(:private_message) { 'Field will always require authentication' }
  let(:private_error) do
    {
      message:    "#{field} field requires authentication",
      extensions: { code: 'AUTHENTICATION_ERROR' }
    }
  end

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
        expect(response[:data][:publicField]).to eq(public_message)
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
          expect(response[:data][:privateField]).to eq(private_message)
        end

        context 'when using a SchemaUser' do
          let(:resource) { create(:schema_user, :confirmed) }

          it 'allows to perform the query' do
            expect(response[:data][:privateField]).to eq(private_message)
          end
        end
      end
    end

    context 'when using an interpreter schema' do
      let(:schema) { InterpreterSchema }

      context 'when user is authenticated' do
        let(:resource) { user }

        it 'allows to perform the query' do
          expect(response[:data][:privateField]).to eq(private_message)
        end
      end
    end
  end

  describe 'user' do
    let(:user_data) { { email: user.email, id: user.id } }
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
      context 'when user is authenticated' do
        let(:resource) { user }

        it 'allows to perform the query' do
          expect(response[:data][:user]).to match(**user_data)
        end
      end
    end

    context 'when using an interpreter schema' do
      let(:schema) { InterpreterSchema }

      context 'when user is authenticated' do
        let(:resource) { user }

        it 'allows to perform the query' do
          expect(response[:data][:user]).to match(**user_data)
        end
      end

      context 'when user is not authenticated' do
        # Interpreter schema fields are public unless specified otherwise (plugin setting)
        it 'allows to perform the query' do
          expect(response[:data][:user]).to match(**user_data)
        end
      end
    end
  end
end
