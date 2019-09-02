module GraphqlDevise
  class UserError < GraphQL::ExecutionError
    def to_h
      super.merge(extensions: { code: ERROR_CODES.fetch(:user_error) })
    end
  end
end
