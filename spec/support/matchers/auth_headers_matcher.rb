# frozen_string_literal: true

RSpec::Matchers.define :include_auth_headers do
  match do |response|
    auth_headers = %w[uid access-token client].map { |key| response.headers[key] }
    auth_headers.all?(&:present?)
  end
end
