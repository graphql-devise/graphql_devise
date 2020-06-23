# frozen_string_literal: true

module GraphqlDevise
  class DetailedUserError < ExecutionError
    def initialize(message, errors:)
      @message = message
      @errors  = errors

      super(message)
    end

    def to_h
      super.merge(extensions: { code: ERROR_CODES.fetch(:user_error), detailed_errors: @errors })
    end
  end
end
