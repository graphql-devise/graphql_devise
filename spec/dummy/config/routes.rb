Rails.application.routes.draw do
  mount_graphql_devise_for 'User', at: 'api/v1', operations: {
    login:   Mutations::Login,
    sign_up: Mutations::SignUp
  }

  mount_graphql_devise_for(
    'Admin',
    authenticable_type: Types::CustomAdminType,
    at:                 'api/v1/admin'
  )

  post '/api/v1/graphql', to: 'api/v1/graphql#graphql'
end
