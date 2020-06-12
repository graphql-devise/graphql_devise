module GraphqlDevise
  class AuthenticationError < ExecutionError
    def to_h
      super.merge(extensions: { code: ERROR_CODES.fetch(:authentication_error) })
    end
  end
end
