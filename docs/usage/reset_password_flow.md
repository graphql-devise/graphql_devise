# Reset Password Flow
This gem supports two different ways to reset a password on a resource. Each password reset flow has it's own set of
operations and this document will explain in more detail how to use each.
The first and most recently implemented flow is preferred as it requires less steps and doesn't require a mutation
to return a redirect on the response. Flow 2 might be deprecated in the future.

## Flow #1 (Preferred)
This flow only has two steps. Each step name refers to the operation name you can use in the mount options to skip or override.

### 1. send_password_reset_with_token
This mutation will send an email to the specified address if it's found on the system. Returns an error if the email is not found. Here's an example assuming the resource used
for authentication is `User`:
```graphql
mutation {
  userSendPasswordResetWithToken(
    email:       "vvega@wallaceinc.com",
    redirectUrl: "https://google.com"
  ) {
    message
  }
}
```
The email will contain a link to the `redirectUrl` (https://google.com in the example) and append a `reset_password_token` query param. This is the token you will
need to use in the next step in order to reset the password.

### 2. update_password_with_token
This mutation uses the token sent on the email to find the resource you are trying to recover.
All you have to do is send a valid token together with the new password and password confirmation.
Here's an example assuming the resource used for authentication is `User`:

```graphql
mutation {
  userUpdatePasswordWithToken(
    resetPasswordToken: "token_here",
    password: "password123",
    passwordConfirmation: "password123"
  ) {
    authenticatable { email }
    credentials { accessToken }
  }
}
```
The mutation has two fields:
1. `authenticatable`: Just like other mutations, returns the actual resource you just recover the password for.
1. `credentials`: This is a nullable field. It will only return credentials as if you had just logged
in into the app if you explicitly say so by overriding the mutation. The docs have more detail
on how to extend the default behavior of mutations, but
[here](https://github.com/graphql-devise/graphql_devise/blob/8c7c8a5ff1b35fb026e4c9499c70dc5f90b9187a/spec/dummy/app/graphql/mutations/reset_admin_password_with_token.rb)
you can find an example mutation on what needs to be done in order for the mutation to return
credentials after updating the password.

## Flow 2 (Deprecated)
This was the first flow to be implemented, requires an additional step and also to encode a GQL query in a url, so this is not the preferred method.
Each step name refers to the operation name you can use in the mount options to skip or override.

### 1. send_password_reset
This mutation will send an email to the specified address if it's found on the system. Returns an error if the email is not found. Here's an example assuming the resource used
for authentication is `User`:
```graphql
mutation {
  userSendPasswordReset(
    email:       "vvega@wallaceinc.com",
    redirectUrl: "https://google.com"
  ) {
    message
  }
}
```
The email will contain an encoded GraphQL query that holds the reset token and redirectUrl.
The query is described in the next step.

### 2. check_password_token
This query checks the reset password token and if successful changes a column in the DB (`allow_password_change`) to true.
This change will allow for the next step to update the password without providing the current password.
Then, this query will redirect to the provided `redirectUrl` with credentials.

### 3. update_password
This step requires the request to include authentication headers and will allow the user to
update the password if step 2 was successful.
Here's an example assuming the resource used for authentication is `User`:
```graphql
mutation {
  userUpdatePassword(
    password: "password123",
    passwordConfirmation: "password123"
  ) {
    authenticatable { email }
  }
}
```
