# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GraphqlDevise::MountMethod::OperationPreparers::DefaultOperationPreparer do
  describe '#call' do
    subject(:prepared) { default_preparer.call }

    let(:default_preparer)  { described_class.new(selected_operations: operations, custom_keys: custom_keys, model: model, preparer: preparer) }
    let(:confirm_operation) { double(:confirm_operation, graphql_name: nil) }
    let(:sign_up_operation) { double(:sign_up_operation, graphql_name: nil) }
    let(:login_operation)   { double(:confirm_operation, graphql_name: nil) }
    let(:logout_operation)  { double(:sign_up_operation, graphql_name: nil) }
    let(:model)             { User }
    let(:preparer)          { double(:preparer) }
    let(:custom_keys)       { [:login, :logout] }
    let(:operations) do
      {
        confirm: { klass: confirm_operation, authenticatable: false },
        sign_up: { klass: sign_up_operation, authenticatable: true },
        login:   { klass: login_operation, authenticatable: true },
        logout:  { klass: logout_operation, authenticatable: true }
      }
    end

    before do
      allow(default_preparer).to receive(:child_class).with(confirm_operation).and_return(confirm_operation)
      allow(default_preparer).to receive(:child_class).with(sign_up_operation).and_return(sign_up_operation)
      allow(default_preparer).to receive(:child_class).with(login_operation).and_return(login_operation)
      allow(default_preparer).to receive(:child_class).with(logout_operation).and_return(logout_operation)
      allow(preparer).to receive(:call).with(confirm_operation, authenticatable: false).and_return(confirm_operation)
      allow(preparer).to receive(:call).with(sign_up_operation, authenticatable: true).and_return(sign_up_operation)
      allow(preparer).to receive(:call).with(login_operation, authenticatable: true).and_return(login_operation)
      allow(preparer).to receive(:call).with(logout_operation, authenticatable: true).and_return(logout_operation)
    end

    it 'returns only those operations with no custom operation provided' do
      expect(prepared.keys).to contain_exactly(:user_sign_up, :user_confirm)
    end

    it 'prepares default operations' do
      expect(confirm_operation).to receive(:graphql_name).with('UserConfirm')
      expect(sign_up_operation).to receive(:graphql_name).with('UserSignUp')
      expect(preparer).to receive(:call).with(confirm_operation, authenticatable: false)
      expect(preparer).to receive(:call).with(sign_up_operation, authenticatable: true)

      prepared

      expect(confirm_operation.instance_variable_get(:@resource_klass)).to eq(User)
      expect(sign_up_operation.instance_variable_get(:@resource_klass)).to eq(User)
    end

    context 'when no custom keys are provided' do
      let(:custom_keys) { [] }

      it 'returns all selected operations' do
        expect(prepared.keys).to contain_exactly(:user_sign_up, :user_confirm, :user_login, :user_logout)
      end
    end

    context 'when no selected operations are provided' do
      let(:operations) { {} }

      it 'returns all selected operations' do
        expect(prepared.keys).to eq([])
      end
    end
  end
end
