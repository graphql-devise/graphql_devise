module GraphqlDevise
  class UserError < GraphQL::ExecutionError
    def to_h
      super.merge(extensions: { code: 'USER_ERROR' })
    end
  end
end
