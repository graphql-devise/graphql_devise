Rails.application.routes.draw do
  resources :posts
  mount GraphqlDevise::Engine => "/graphql_devise"
end
