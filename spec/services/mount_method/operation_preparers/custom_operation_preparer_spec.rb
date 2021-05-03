# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GraphqlDevise::MountMethod::OperationPreparers::CustomOperationPreparer do
  describe '#call' do
    subject(:prepared) { described_class.new(selected_keys: selected_keys, custom_operations: operations, model: model).call }

    let(:login_operation)  { double(:confirm_operation, graphql_name: nil) }
    let(:logout_operation) { double(:sign_up_operation, graphql_name: nil) }
    let(:model)            { User }
    let(:operations)       { { login: login_operation, logout: logout_operation, invalid: double(:invalid) } }
    let(:selected_keys)    { [:login, :logout, :sign_up, :confirm] }

    it 'returns only those operations with no custom operation provided' do
      expect(prepared.keys).to contain_exactly(:user_login, :user_logout)
    end

    it 'prepares custom operations' do
      expect(login_operation).to receive(:graphql_name).with('UserLogin')
      expect(logout_operation).to receive(:graphql_name).with('UserLogout')

      prepared

      expect(login_operation.instance_variable_get(:@resource_klass)).to eq(User)
      expect(logout_operation.instance_variable_get(:@resource_klass)).to eq(User)
    end

    context 'when no selected keys are provided' do
      let(:selected_keys) { [] }

      it 'returns no operations' do
        expect(prepared).to eq({})
      end
    end

    context 'when no custom operations are provided' do
      let(:operations) { {} }

      it 'returns no operations' do
        expect(prepared).to eq({})
      end
    end
  end
end
