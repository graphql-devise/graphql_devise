# GraphqlDevise
[![Build Status](https://travis-ci.org/graphql-devise/graphql_devise.svg?branch=master)](https://travis-ci.org/graphql-devise/graphql_devise)
[![Coverage Status](https://coveralls.io/repos/github/graphql-devise/graphql_devise/badge.svg?branch=master)](https://coveralls.io/github/graphql-devise/graphql_devise?branch=master)
[![Gem Version](https://badge.fury.io/rb/graphql_devise.svg)](https://badge.fury.io/rb/graphql_devise)

GraphQL interface on top of the [Devise Token Auth](https://github.com/lynndylanhurley/devise_token_auth) (DTA) gem.

## Table of Contents

<!--ts-->
   * [GraphqlDevise](#graphqldevise)
      * [Table of Contents](#table-of-contents)
      * [Introduction](#introduction)
      * [Installation](#installation)
      * [Usage](#usage)
         * [Mounting Routes manually](#mounting-routes-manually)
            * [Available Operations](#available-operations)
         * [Configuring Model](#configuring-model)
         * [Customizing Email Templates](#customizing-email-templates)
         * [I18n](#i18n)
         * [Authenticating Controller Actions](#authenticating-controller-actions)
         * [Making Requests](#making-requests)
            * [Mutations](#mutations)
            * [Queries](#queries)
         * [More Configuration Options](#more-configuration-options)
            * [Devise Token Auth Initializer](#devise-token-auth-initializer)
            * [Devise Initializer](#devise-initializer)
         * [Using Alongside Standard Devise](#using-alongside-standard-devise)
      * [Future Work](#future-work)
      * [Contributing](#contributing)
      * [License](#license)

<!-- Added by: mcelicalderon, at: Tue Apr 28 21:43:30 -05 2020 -->

<!--te-->

## Introduction
This gem heavily relies on two gems, [Devise Token Auth](https://github.com/lynndylanhurley/devise_token_auth) (DTA)
and [Devise](https://github.com/heartcombo/devise) which is a dependency of DTA.
It provides a GraphQL interface on top of DTA which is designed to work with REST APIs. That's why
things like token management, token expiration and everything up until using the actual GraphQL schema is
still controlled by DTA. For that reason you will find that our generator runs these two gems generator and two
initializer files are included. We'll provide more configuration details in the
[configuration section](#more-configuration-options),
but **we recommend you get familiar with [DTA and their docs](https://github.com/lynndylanhurley/devise_token_auth)
in order to use this gem to its full potential**.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'graphql_devise'
```

And then execute:

    $ bundle

Next, you need to run the generator:

    $ bundle exec rails generate graphql_devise:install

Graphql Devise generator will execute `Devise` and `Devise Token Auth`
generators for you. These will make the required changes for the gems to
work correctly. All configurations for [Devise](https://github.com/plataformatec/devise) and
[Devise Token Auth](https://github.com/lynndylanhurley/devise_token_auth) are available,
so you can read the docs there to customize your options.
Configurations are done via initializer files as usual, one per gem.

The generator accepts 2 params: `user_class` and `mount_path`. The params
will be used to mount the route in `config/routes.rb`. For instance the executing:

```bash
$ bundle exec rails g graphql_devise:install Admin api/auth
```

Will do the following:
- Execute `Devise` install generator
- Execute `Devise Token Auth` install generator with `Admin` and `api/auth` as params
  - Find or create `Admin` model
  - Add `devise` modules to `Admin` model
  - Other changes that you can find [here](https://devise-token-auth.gitbook.io/devise-token-auth/config)
- Add the route to `config/routes.rb`
  - `mount_graphql_devise_for 'Admin', at: 'api/auth'`

`Admin` could be any model name you are going to be using for authentication,
and `api/auth` could be any mount path you would like to use for auth.

**Important:** Remember this gem mounts a completely separate GraphQL schema on a separate controller in the route
provided by the `at` option in the `mount_graphql_devise_for` method in the `config/routes.rb` file. If no `at`
option is provided, the route will be `/graphql_auth`. This has no effect on your own application schema.
More on this in the next section.

## Usage
### Mounting Routes manually
Routes can be added using the initializer or manually.
You can mount this gem's GraphQL auth schema in your routes file like this:

```ruby
# config/routes.rb

Rails.application.routes.draw do
  mount_graphql_devise_for(
    'User',
    at: 'api/v1',
    authenticatable_type: Types::MyCustomUserType,
    operations: {
      login: Mutations::Login
    },
    skip: [:sign_up],
    additional_mutations: {
      # generates mutation { adminUserSignUp }
      admin_user_sign_up: Mutations::AdminUserSignUp
    },
    additional_queries: {
      # generates query { publicUserByUuid }
      public_user_by_uuid: Resolvers::UserByUuid
    }
  )
end
```

Here are the options for the mount method:

1. `at`: Route where the GraphQL schema will be mounted on the Rails server. In this example your API will have these two routes: `POST /api/v1/graphql_auth` and `GET /api/v1/graphql_auth`.
If this option is not specified, the schema will be mounted at `/graphql_auth`.
1. `operations`: Specifying this is optional. Here you can override default
behavior by specifying your own mutations and queries for every GraphQL operation.
Check available operations in this file [mutations](https://github.com/graphql-devise/graphql_devise/blob/b5985036e01ea064e43e457b4f0c8516f172471c/lib/graphql_devise/rails/routes.rb#L19)
and [queries](https://github.com/graphql-devise/graphql_devise/blob/b5985036e01ea064e43e457b4f0c8516f172471c/lib/graphql_devise/rails/routes.rb#L41).
All mutations and queries are built so you can extend default behavior just by extending
our default classes and yielding your customized code after calling `super`, example
[here](https://github.com/graphql-devise/graphql_devise/blob/b5985036e01ea064e43e457b4f0c8516f172471c/spec/dummy/app/graphql/mutations/login.rb#L6).
1. `authenticatable_type`: By default, the gem will add an `authenticatable` field to every mutation
and an `authenticatable` type to every query. Gem will try to use `Types::<model>Type` by
default, so in our example you could define `Types::UserType` and every query and mutation
will use it. But, you can override this type with this option like in the example.
1. `skip`: An array of the operations that should not be available in the authentication schema. All these operations are
symbols and should belong to the list of available operations in the gem.
1. `only`: An array of the operations that should be available in the authentication schema. The `skip` and `only` options are
mutually exclusive, an error will be raised if you pass both to the mount method.
1. `additional_mutations`: Here you can add as many mutations as you
need, for those features that don't fully match the provided default mutations and queries.
You need to provide a hash to this option, and
each key will be the name of the mutation on the schema. Also, the value provided must be a valid mutation.
This is similar to what you can accomplish with
[devise_scope](https://www.rubydoc.info/github/heartcombo/devise/master/ActionDispatch/Routing/Mapper%3Adevise_for).
1. `additional_queries`: Here you can add as many queries as you need,
for those features that don't fully match the provided default mutations and queries.
You need to provide a hash to this option, and
each key will be the name of the query on the schema. Also, the value provided must be a valid Resolver.
This is also similar to what you can accomplish with
[devise_scope](https://www.rubydoc.info/github/heartcombo/devise/master/ActionDispatch/Routing/Mapper%3Adevise_for).

Additional mutations and queries will be added to the schema regardless
of other options you might have specified like `skip` or `only`.
Additional queries and mutations is usually a good place for other
operations on your schema that require no authentication (like sign_up).
Also by adding them through the mount method, your mutations and
resolvers can inherit from our [base mutation](https://github.com/graphql-devise/graphql_devise/blob/master/app/graphql/graphql_devise/mutations/base.rb)
or [base resolver](https://github.com/graphql-devise/graphql_devise/blob/master/app/graphql/graphql_devise/resolvers/base.rb)
respectively, to take advantage of some of the methods provided by devise
just like with `devise_scope`

#### Available Operations
The following is a list of the symbols you can provide to the `operations`, `skip` and `only` options of the mount method:
```ruby
:login
:logout
:sign_up
:update_password
:send_password_reset
:confirm_account
:check_password_token
```


### Configuring Model
Just like with Devise and DTA, you need to include a module in your authenticatable model,
so with our example, your user model will have to look like this:
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

The install generator can do this for you if you specify the `user_class` option.
See [Installation](#installation) for details.

### Customizing Email Templates
The approach of this gem is a bit different from DeviseTokenAuth. We have placed our templates in `app/views/graphql_devise/mailer`,
so if you want to change them, place yours on the same dir structure on your Rails project. You can customize these two templates:
1. `app/views/graphql_devise/mailer/confirmation_instructions.html.erb`
1. `app/views/graphql_devise/mailer/reset_password_instructions.html.erb`

The main reason for this difference is just to make it easier to have both Standard `Devise` and this gem running at the same time.
Check [these files](app/views/graphql_devise/mailer) to see the available helper methods you can use in your views.

### I18n
GraphQL Devise supports locales. For example, the `graphql_devise.confirmations.send_instructions` locale setting supports the `%{email}` variable in case you would like to include it in the resend confirmation instructions for the user. Take a look at our [locale file](https://github.com/graphql-devise/graphql_devise/blob/master/config/locales/en.yml) to see all of the available messages.

Keep in mind that if your app uses multiple locales, you should set the `I18n.locale` accordingly. You can learn how to do this [here](https://guides.rubyonrails.org/i18n.html).

### Authenticating Controller Actions
Just like with Devise or DTA, you will need to authenticate users in your controllers.
For this you need to call `authenticate_<model>!` in a before_action hook of your controller.
In our example our model is `User`, so it would look like this:
```ruby
# app/controllers/my_controller.rb

class MyController < ApplicationController
  include GraphqlDevise::Concerns::SetResourceByToken

  before_action :authenticate_user!

  def my_action
    render json: { current_user: current_user }
  end
end
```

The install generator can do this for you because it executes DTA installer.
See [Installation](#Installation) for details.

### Making Requests
Here is a list of the available mutations and queries assuming your mounted model is `User`.

#### Mutations
1. `userLogin(email: String!, password: String!): UserLoginPayload`

    This mutation has a second field by default. `credentials` can be fetched directly on the mutation return type.
    Credentials are still returned in the headers of the response.

1. `userLogout: UserLogoutPayload`
1. `userSignUp(email: String!, password: String!, passwordConfirmation: String!, confirmSuccessUrl: String): UserSignUpPayload`

   The parameter `confirmSuccessUrl` is optional unless you are using the `confirmable` plugin from Devise in your `resource`'s model. If you have `confirmable` set up, you will have to provide it unless you have `config.default_confirm_success_url` set in `config/initializers/devise_token_auth.rb`.
1. `userSendResetPassword(email: String!, redirectUrl: String!): UserSendReserPasswordPayload`
1. `userUpdatePassword(password: String!, passwordConfirmation: String!, currentPassword: String): UserUpdatePasswordPayload`

    The parameter `currentPassword` is optional if you have `config.check_current_password_before_update` set to
    false (disabled by default) on your generated `config/initializers/devise_token_aut.rb` or if the `resource`
    model supports the `recoverable` Devise plugin and the `resource`'s `allow_password_change` attribute is set to true (this is done in the `userCheckPasswordToken` query when you click on the sent email's link).
1. `userResendConfirmation(email: String!, redirectUrl: String!): UserResendConfirmationPayload`

    The `UserResendConfirmationPayload` will return the `authenticatable` resource that was sent the confirmation instructions but also has a `message: String!` that can be used to notify a user what to do after the instructions were sent to them

#### Queries
1. `userConfirmAccount(confirmationToken: String!, redirectUrl: String!): User`
1. `userCheckPasswordToken(resetPasswordToken: String!, redirectUrl: String): User`

The reason for having 2 queries is that these 2 are going to be accessed when clicking on
the confirmation and reset password email urls. There is no limitation for making mutation
requests using the `GET` method on the Rails side, but looks like there might be a limitation
on the [Apollo Client](https://www.apollographql.com/docs/apollo-server/v1/requests/#get-requests).

We will continue to build better docs for the gem after this first release, but in the mean time
you can use [our specs](spec/requests) to better understand how to use the gem.
Also, the [dummy app](spec/dummy) used in our specs will give you
a clear idea on how to configure the gem on your Rails application.

### More Configuration Options
As mentioned in the introduction there are many configurations that will change how this gem behaves. You can change
this values on the initializer files generated by the installer.

#### Devise Token Auth Initializer
The generated initializer file `config/initializers/devise_token_auth.rb` has all the available options documented
as comments. You can also use
**[DTA's docs](https://devise-token-auth.gitbook.io/devise-token-auth/config/initialization)** as a reference.
In this section the most important configurations will be highlighted.

- **change_headers_on_each_request:** This configurations defaults to `false`. This will allow you to store the
  credentials for as long as the token life_span permits. And you can send the same credentials in each request.
  Setting this to `true` means that tokens will change on each request you make, and the new values will be returned
  in the headers. So your client needs to handle this.
- **batch_request_buffer_throttle:** When change_headers_on_each_request is set to true, you might still want your
  credentials to be valid more than once as you might send parallel request. The duration you set here will
  determine how long the same credentials work after the first request is received.
- **token_lifespan:** This configuration takes a duration and you can set it to a value like
  `1.month`, `2.weeks`, `1.hour`, etc.

**Note:** Remember this gem adds a layer on top of DTA, so some configurations might not apply.

#### Devise Initializer
The generated initializer file `config/initializers/devise_token_auth.rb` has all the available options documented
as comments. You can also use
**[Devise's docs](https://github.com/heartcombo/devise)** as a reference.
In this section the most important configurations will be highlighted.

- **password_length:** You can change this value to validate password length on sign up and password update
  (must enable the validatable module).
- **mailer_sender:** Set it to a string with the sender's email address like `'support@example.com'`.
- **case_insensitive_keys:** Setting a value like `[:email]` will make email field case insensitive on login, sign up, etc.
- **email_regexp:** You can customize the regex that will validate the format of email addresses (must enable the validatable module).

**Note:** Remember this gem adds a layer on top of Devise, so some configurations might not apply.

### Using Alongside Standard Devise
The DeviseTokenAuth gem allows experimental use of the standard Devise gem to be configured at the same time, for more
information you can check [this answer here](https://github.com/lynndylanhurley/devise_token_auth/blob/2a32f18ccce15638a74e72f6cfde5cf15a808d3f/docs/faq.md#can-i-use-this-gem-alongside-standard-devise).

This gem supports the same and should be easier to handle email templates due to the fact we don't override
standard Devise templates.

## Future Work
We will continue to improve the gem and add better docs.

1. Add mount option that will create a separate schema for the mounted resource.
1. Make sure this gem can correctly work alongside DTA and the original Devise gem.
1. Improve DOCS.
1. Add support for unlockable and other Devise modules.
1. Add feature specs for confirm account and reset password flows.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/graphql-devise/graphql_devise.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
