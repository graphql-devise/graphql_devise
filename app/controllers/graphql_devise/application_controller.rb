# frozen_string_literal: true

module GraphqlDevise
  ApplicationController = if Rails::VERSION::MAJOR >= 5
    Class.new(ActionController::API)
  else
    Class.new(ActionController::Base)
  end
end
