# Generators are not automatically loaded by Rails
require 'rails_helper'
require 'generators/graphql_devise/install_generator'

RSpec.describe GraphqlDevise::InstallGenerator, type: :generator do
  destination File.expand_path('../../../tmp', __FILE__)

  before do
    prepare_destination
    allow_any_instance_of(described_class).to receive(:create_devise_initializer)
    allow_any_instance_of(described_class).to receive(:execute_dta_installer)
  end

  let(:routes_path)    { "#{destination_root}/config/routes.rb" }
  let(:routes_content) { File.read(routes_path) }
  let(:dta_route)      { "mount_devise_token_auth_for 'User', at: 'auth'" }

  context 'when the file exists' do
    before do
      create_file_with_content(
        routes_path,
        "Rails.application.routes.draw do\n#{dta_route}\nend"
      )
    end

    context 'when passing no params to the generator' do
      before { run_generator }

      it 'replaces dta route using the default values for class and path' do
        generator_added_route = /  mount_graphql_devise_for 'User', at: 'auth'/
        expect(routes_content).to match(generator_added_route)
        expect(routes_content).not_to match(dta_route)
      end
    end

    context 'when passing custom params to the generator' do
      before { run_generator %w[Admin api] }

      it 'add the routes using the provided values for class and path and keeps dta route' do
        generator_added_route = /  mount_graphql_devise_for 'Admin', at: 'api'/
        expect(routes_content).to match(generator_added_route)
        expect(routes_content).to match(dta_route)
      end
    end
  end

  context 'when file does *NOT* exist' do
    before { run_generator }

    it 'does *NOT* create the file and throw no exception' do
      expect(File.exist?(routes_path)).to be_falsey
    end
  end
end
