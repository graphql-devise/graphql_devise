Rails.application.routes.draw do
  mount_graphql_devise_for 'User', at: 'api/v1'
end
