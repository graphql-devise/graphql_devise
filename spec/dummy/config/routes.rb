Rails.application.routes.draw do
  mount_graphql_devise_for 'User', at: 'api/v1', mutations: {
    login: Mutations::Login,
    signUp: Mutations::SignUp
  }
end
