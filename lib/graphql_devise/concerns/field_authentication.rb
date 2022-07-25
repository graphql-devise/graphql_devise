# frozen_string_literal: true

module GraphqlDevise
  module FieldAuthentication
    extend ActiveSupport::Concern

    def initialize(*args, authenticate: nil, **kwargs, &block)
      @authenticate = authenticate
      super(*args, **kwargs, &block)
    end

    attr_reader :authenticate
  end
end
