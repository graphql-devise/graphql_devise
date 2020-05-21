# Generators are not automatically loaded by Rails
require 'rails_helper'
require 'generators/graphql_devise/install_generator'

RSpec.describe GraphqlDevise::InstallGenerator, type: :generator do
  destination File.expand_path('../../../../dummy', __dir__)

  before do
    prepare_destination
    create_rails_project
  end

  let(:routes_path)    { "#{destination_root}/config/routes.rb" }
  let(:routes_content) { File.read(routes_path) }
  let(:dta_route)      { 'mount_devise_token_auth_for' }

  context 'when passing no params to the generator' do
    before { run_generator }

    it 'creates and updated required files' do
      assert_file 'config/routes.rb', /\s{2,}mount_graphql_devise_for 'User', at: 'auth'/
      expect(routes_content).not_to match(dta_route)

      assert_file 'config/initializers/devise.rb'
      assert_file 'config/initializers/devise_token_auth.rb'
    end
  end

  context 'when passing custom params to the generator' do
    before { run_generator %w[Admin api] }

    it 'creates and updated required files' do
      assert_file 'config/routes.rb', /\s{2,}mount_graphql_devise_for 'Admin', at: 'api'/
      expect(routes_content).not_to match(dta_route)

      assert_file 'config/initializers/devise.rb'
      assert_file 'config/initializers/devise_token_auth.rb'
    end
  end

  def create_rails_project
    FileUtils.cd(File.join(destination_root, '..')) do
      `rails new dummy -S -C --skip-action-mailbox --skip-action-text -T --skip-spring --skip-bundle --skip-keeps -G --skip-active-storage -J --skip-listen --skip-bootsnap`
    end
  end
end
