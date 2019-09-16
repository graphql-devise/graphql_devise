module Types
  class QueryType < Types::BaseObject
    field :user, resolver: Resolvers::UserShow
  end
end
