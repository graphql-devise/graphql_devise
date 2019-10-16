# Generators are not automatically loaded by Rails
require 'rails_helper'
require 'fileutils'
require 'generators/graphql_devise/install_generator'

RSpec.describe GraphqlDevise::InstallGenerator, type: :generator do
  destination File.expand_path("../../../tmp", __FILE__)
  arguments %w(User auth)

  before do
    prepare_destination
    FileUtils::mkdir(config_path)
    File.open(routes_path, "w") do |f|
      f.write('Rails.application.routes.draw do')
      f.write("\nend")
    end
    run_generator
  end

  let(:config_path) { "#{destination_root}/config" }
  let(:routes_path) { "#{config_path}/routes.rb" }
  let(:routes_content) { File.read(routes_path) }

  it 'add the routes to config/routes.rb' do
    generator_added_route = /  mount_graphql_devise_for 'User', at: 'auth'/
    expect(routes_content).to match(generator_added_route)
  end
end
