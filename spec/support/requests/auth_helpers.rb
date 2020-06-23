# frozen_string_literal: true

module Requests
  module AuthHelpers
    def auth_headers_for(user)
      user.create_new_auth_token
    end
  end
end
