# GraphqlDevise
[![Build Status](https://travis-ci.org/graphql-devise/graphql_devise.svg?branch=master)](https://travis-ci.org/graphql-devise/graphql_devise)
[![Gem Version](https://badge.fury.io/rb/graphql_devise.svg)](https://badge.fury.io/rb/graphql_devise)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'graphql_devise'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install graphql_devise

GraphQL interface on top of the [Devise Token Auth](https://github.com/lynndylanhurley/devise_token_auth) (DTA) gem.

## Usage
All configurations for [Devise](https://github.com/plataformatec/devise) and
[Devise Token Auth](https://github.com/lynndylanhurley/devise_token_auth) are
available, so you can read the docs there to customize your options.
Configurations are done via initializer files as usual, one per gem.
You can generate most of the configuration by using DTA's installer while we work
on our own generators like this
```bash
$ rails g devise_token_auth:install User auth
```
`User` could be any model name you are going to be using for authentication,
and `auth` could be anything as we will be removing that from the routes file.

### Mounting Routes
First, you need to mount the gem in the routes file like this
```ruby
# config/routes.rb

Rails.application.routes.draw do
  mount_graphql_devise_for 'User', at: 'api/v1', authenticable_type: Types::CustomUserType, operations: {
    login: Mutations::Login
  }
```
If you used DTA's installer you will have to remove the `mount_devise_token_auth_for`
line.

Here are the option for the mount method:

1. `at`: Route where the GraphQL schema will be mounted on the Rails server. In the
example your API will have this two routes `POST /api/v1//graphql_auth` `GET /api/v1//graphql_auth`.
If no this option is not specified, the schema will be mounted at `/graphql_auth`.
1. `operations`: Specifying this one is optional. Here you can override default
behavior by specifying your own mutations and queries for every GraphQL operation.
Check available operations in this file [mutations](https://github.com/graphql-devise/graphql_devise/blob/b5985036e01ea064e43e457b4f0c8516f172471c/lib/graphql_devise/rails/routes.rb#L19)
and [queries](https://github.com/graphql-devise/graphql_devise/blob/b5985036e01ea064e43e457b4f0c8516f172471c/lib/graphql_devise/rails/routes.rb#L41).
All mutations and queries are build so you can extend default behavior just by extending
our default classes and yielding your customized code after calling `super`, example
[here](https://github.com/graphql-devise/graphql_devise/blob/b5985036e01ea064e43e457b4f0c8516f172471c/spec/dummy/app/graphql/mutations/login.rb#L6).
1. `authenticable_type`: By default, the gem will add an `authenticable` field to every mutation
and an `authenticable` type to every query. Gem will try to use `Types::<model>Type` by
default, so in our example you could define `Types::UserType` and every query and mutation
will use it. But, you can override this type with this option like in the example.

### Configuring Model
Just like with Devise and DTA, you need to include a module in your authenticable model,
so as for our example, your user model will have to look like this:
```ruby
# app/models/user.rb

class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :lockable,
         :validatable,
         :confirmable

  # including after calling the `devise` method is important.
  include GraphqlDevise::Concerns::Model
end
```

### Authenticating Controller Actions
Just like with Devise or DTA, you will need to authenticate users in your controllers.
For this you need to call `authenticate_<model>!` in a before_action hook of your controller.
In our example our model is `User`, so it would look like this:
```ruby
# app/controllers/my_controller.rb

class MyController < ApplicationController
  before_action :authenticate_user!

  def my_action
    render json: { current_user: current_user }
  end
end
```

### Making Requests
Here is a list of the available mutations and queries assuming your mounted model
is `User`.

#### Mutations
1. userLogin
1. userLogout
1. userSignUp
1. userUpdatePassword
1. userSendResetPassword

#### Queries
1. userConfirmAccount
1. userCheckPasswordToken

The reason for having 2 queries is that these 2 are going to be accessed when clicking on
the confirmation and reset password email urls. There is no limitation for making mutation
requests using the `GET` method on the Rails side, but looks like there might be a limitation
on the [Apollo Client](https://www.apollographql.com/docs/apollo-server/v1/requests/#get-requests).

We will continue to build better docs for the gem after this first release, but on the mean time
you can use [our specs](https://github.com/graphql-devise/graphql_devise/tree/b5985036e01ea064e43e457b4f0c8516f172471c/spec/requests) to better understand how to use the gem.
Also, the [dummy app](https://github.com/graphql-devise/graphql_devise/tree/b5985036e01ea064e43e457b4f0c8516f172471c/spec/dummy) used in our specs will give you
a clear idea on how to configure the gem on your Rails application.

## Future Work
We will continue to improve the gem and add better docs.

1. Add install generator.
1. Support more options on the mount method.
1. Better support for multiple mounted models (it already works by mounting in different routes).
1. Make sure this gem can correctly work alongside DTA and the original Devise gem.
1. Improve DOCS.
1. Add support for unlockable and other Devise modules.
1. Add feature specs for confirm account and reset password flows.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/graphql-devise/graphql_devise.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
