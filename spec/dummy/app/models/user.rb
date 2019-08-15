class User < ApplicationRecord
  include GraphqlDevise::Concerns::Models::Testable
end
