# frozen_string_literal: true

module GraphqlDevise
  class UserError < ExecutionError
    def to_h
      super.merge(extensions: { code: ERROR_CODES.fetch(:user_error) })
    end
  end
end
