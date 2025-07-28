# frozen_string_literal: true

# Generators are not automatically loaded by Rails
require 'rails_helper'
require 'generators/graphql_devise/install_generator'

# NOTE: Skipping tests because of a problem between zeitwerk and GQL versions 2.1.0 & 2.2.14
skip_generator_tests =
  Gem::Version.new(GraphQL::VERSION).between?(
    Gem::Version.new('2.1.0'),
    Gem::Version.new('2.2.14')
  ) && Gem::Version.new(Rails.version) >= Gem::Version.new('7.0.0')

RSpec.describe GraphqlDevise::InstallGenerator, type: :generator, skip: skip_generator_tests do
  destination File.expand_path('../../../../gqld_dummy', __dir__)

  let(:routes_path)    { "#{destination_root}/config/routes.rb" }
  let(:routes_content) { File.read(routes_path) }
  let(:dta_route)      { 'mount_devise_token_auth_for' }

  after(:all) { FileUtils.rm_rf(destination_root) }

  before do
    prepare_destination
    create_rails_project
    run_generator(args)
  end

  context 'when mount option is schema' do
    let(:args) { ['Admin', '--mount', 'GqldDummySchema'] }

    it 'mounts the SchemaPlugin' do
      assert_file 'config/initializers/devise.rb'
      assert_file 'config/initializers/devise_token_auth.rb', /^\s{2}#{Regexp.escape('config.change_headers_on_each_request = false')}/
      assert_file 'config/locales/devise.en.yml'

      assert_migration 'db/migrate/devise_token_auth_create_admins.rb'

      assert_file 'app/models/admin.rb', /^\s{2}devise :.+include GraphqlDevise::Authenticatable/m

      assert_file 'app/controllers/application_controller.rb', /^\s{2}include GraphqlDevise::SetUserByToken/

      assert_file 'app/graphql/gqld_dummy_schema.rb', /\s+#{Regexp.escape("GraphqlDevise::ResourceLoader.new(Admin)")}/
    end
  end

  context 'when passing no params to the generator' do
    let(:args) { [] }

    it 'creates and updated required files' do
      assert_file 'config/routes.rb', /^\s{2}mount_graphql_devise_for User, at: 'graphql_auth'/
      expect(routes_content).not_to match(dta_route)

      assert_file 'config/initializers/devise.rb'
      assert_file 'config/initializers/devise_token_auth.rb', /^\s{2}#{Regexp.escape('config.change_headers_on_each_request = false')}/
      assert_file 'config/locales/devise.en.yml'

      assert_migration 'db/migrate/devise_token_auth_create_users.rb'

      assert_file 'app/models/user.rb', /^\s{2}devise :.+include GraphqlDevise::Authenticatable/m

      assert_file 'app/controllers/application_controller.rb', /^\s{2}include GraphqlDevise::SetUserByToken/
    end
  end

  context 'when passing custom params to the generator' do
    let(:args) { %w[Admin api] }

    it 'creates and updated required files' do
      assert_file 'config/routes.rb', /^\s{2}mount_graphql_devise_for Admin, at: 'api'/
      expect(routes_content).not_to match(dta_route)

      assert_file 'config/initializers/devise.rb'
      assert_file 'config/initializers/devise_token_auth.rb', /^\s{2}#{Regexp.escape('config.change_headers_on_each_request = false')}/
      assert_file 'config/locales/devise.en.yml'

      assert_migration 'db/migrate/devise_token_auth_create_admins.rb'

      assert_file 'app/models/admin.rb', /^\s{2}devise :.+include GraphqlDevise::Authenticatable/m

      assert_file 'app/controllers/application_controller.rb', /^\s{2}include GraphqlDevise::SetUserByToken/
    end
  end

  def create_rails_project
    FileUtils.cd(File.join(destination_root, '..')) do
      `rails new gqld_dummy -S -C --skip-action-mailbox --skip-action-text -T --skip-spring --skip-bundle --skip-keeps -G --skip-active-storage -J --skip-listen --skip-bootsnap`
    end
    FileUtils.cd(File.join(destination_root, '../gqld_dummy')) do
      `rm -f config/initializers/assets.rb`
    end
    FileUtils.cd(File.join(destination_root, '../gqld_dummy')) do
      `rails generate graphql:install`
    end
  end
end
