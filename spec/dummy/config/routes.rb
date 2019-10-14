Rails.application.routes.draw do
  mount_graphql_devise_for 'User', at: '/api/v1/graphql_auth', operations: {
    login:   Mutations::Login,
    sign_up: Mutations::SignUp
  }

  mount_graphql_devise_for(
    'Admin',
    authenticable_type: Types::CustomAdminType,
    skip:               [:sign_up, :check_password_token],
    at:                 '/api/v1/admin/graphql_auth'
  )

  mount_graphql_devise_for(
    'Guest',
    only: [:login, :logout],
    at:   '/api/v1/guest/graphql_auth'
  )

  post '/api/v1/graphql', to: 'api/v1/graphql#graphql'
end
