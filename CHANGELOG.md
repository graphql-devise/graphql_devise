# Changelog

## [v0.11.4](https://github.com/graphql-devise/graphql_devise/tree/v0.11.4) (2020-05-23)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.11.3...v0.11.4)

**Implemented enhancements:**

- Do nothing if forgery protection enabled in ApplicationController [\#93](https://github.com/graphql-devise/graphql_devise/pull/93) ([mcelicalderon](https://github.com/mcelicalderon))

## [v0.11.3](https://github.com/graphql-devise/graphql_devise/tree/v0.11.3) (2020-05-23)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.11.2...v0.11.3)

**Implemented enhancements:**

- Default `change\_headers\_on\_each\_request` to false [\#76](https://github.com/graphql-devise/graphql_devise/issues/76)
- Replace the auth model concern on generator execution [\#53](https://github.com/graphql-devise/graphql_devise/issues/53)
- Generator. Use our modules, change defaults [\#91](https://github.com/graphql-devise/graphql_devise/pull/91) ([mcelicalderon](https://github.com/mcelicalderon))

## [v0.11.2](https://github.com/graphql-devise/graphql_devise/tree/v0.11.2) (2020-05-07)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.11.1...v0.11.2)

**Fixed bugs:**

- Avoid multiple schema and type load \(Devise behavior\) [\#88](https://github.com/graphql-devise/graphql_devise/pull/88) ([mcelicalderon](https://github.com/mcelicalderon))

## [v0.11.1](https://github.com/graphql-devise/graphql_devise/tree/v0.11.1) (2020-05-05)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.11.0...v0.11.1)

**Implemented enhancements:**

- Honor Devise's case insensitive fields [\#81](https://github.com/graphql-devise/graphql_devise/pull/81) ([mcelicalderon](https://github.com/mcelicalderon))

**Fixed bugs:**

- Add query and mutation type only once after app routes [\#87](https://github.com/graphql-devise/graphql_devise/pull/87) ([mcelicalderon](https://github.com/mcelicalderon))

**Closed issues:**

- Get the Mutations going [\#83](https://github.com/graphql-devise/graphql_devise/issues/83)
- Improve docs. Better reference to Devise and DTA. [\#75](https://github.com/graphql-devise/graphql_devise/issues/75)
- Add case insensitive fields to sign\_up and login [\#66](https://github.com/graphql-devise/graphql_devise/issues/66)

**Merged pull requests:**

- Improve readme file [\#84](https://github.com/graphql-devise/graphql_devise/pull/84) ([mcelicalderon](https://github.com/mcelicalderon))

## [v0.11.0](https://github.com/graphql-devise/graphql_devise/tree/v0.11.0) (2020-04-11)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.10.1...v0.11.0)

**Breaking changes:**

- Make Authenticatable type not null [\#80](https://github.com/graphql-devise/graphql_devise/pull/80) ([mcelicalderon](https://github.com/mcelicalderon))

**Implemented enhancements:**

- Add mount method option sanitizer [\#78](https://github.com/graphql-devise/graphql_devise/pull/78) ([mcelicalderon](https://github.com/mcelicalderon))

**Fixed bugs:**

- Refactor mount method operations [\#79](https://github.com/graphql-devise/graphql_devise/pull/79) ([mcelicalderon](https://github.com/mcelicalderon))
- Fix routes GQL ruby \(v1.10.0\) version check [\#74](https://github.com/graphql-devise/graphql_devise/pull/74) ([mcelicalderon](https://github.com/mcelicalderon))

## [v0.10.1](https://github.com/graphql-devise/graphql_devise/tree/v0.10.1) (2020-03-21)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.10.0...v0.10.1)

**Fixed bugs:**

- Routes mount\_graphql\_devise\_for with module not work [\#69](https://github.com/graphql-devise/graphql_devise/issues/69)
- Fix mounting models inside another module [\#70](https://github.com/graphql-devise/graphql_devise/pull/70) ([mcelicalderon](https://github.com/mcelicalderon))

## [v0.10.0](https://github.com/graphql-devise/graphql_devise/tree/v0.10.0) (2020-02-04)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.9.2...v0.10.0)

**Implemented enhancements:**

- Add additional mutations and queries option [\#64](https://github.com/graphql-devise/graphql_devise/pull/64) ([mcelicalderon](https://github.com/mcelicalderon))

## [v0.9.2](https://github.com/graphql-devise/graphql_devise/tree/v0.9.2) (2020-02-02)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.9.1...v0.9.2)

**Implemented enhancements:**

- Fix bug with GQL 1.10 [\#62](https://github.com/graphql-devise/graphql_devise/pull/62) ([mcelicalderon](https://github.com/mcelicalderon))

**Fixed bugs:**

- mutation': Second definition of 'mutation\(...\)' \(GraphqlDevise::Types::MutationType\) is invalid [\#59](https://github.com/graphql-devise/graphql_devise/issues/59)

**Merged pull requests:**

- Add mailer locale doc [\#44](https://github.com/graphql-devise/graphql_devise/pull/44) ([aarona](https://github.com/aarona))

## [v0.9.1](https://github.com/graphql-devise/graphql_devise/tree/v0.9.1) (2019-12-26)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.9.0...v0.9.1)

## [v0.9.0](https://github.com/graphql-devise/graphql_devise/tree/v0.9.0) (2019-12-26)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.8.1...v0.9.0)

**Implemented enhancements:**

- Allow returning auth info as part to the response type [\#50](https://github.com/graphql-devise/graphql_devise/issues/50)
- Return credentials field in login mutation [\#55](https://github.com/graphql-devise/graphql_devise/pull/55) ([mcelicalderon](https://github.com/mcelicalderon))

**Fixed bugs:**

- Error when including this gem's controller concern [\#47](https://github.com/graphql-devise/graphql_devise/issues/47)
- Fix concern aliases [\#54](https://github.com/graphql-devise/graphql_devise/pull/54) ([mcelicalderon](https://github.com/mcelicalderon))

## [v0.8.1](https://github.com/graphql-devise/graphql_devise/tree/v0.8.1) (2019-11-27)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.8.0...v0.8.1)

**Fixed bugs:**

- Add dummy query field if none is provided. Works when devise\_invitable is loaded [\#48](https://github.com/graphql-devise/graphql_devise/pull/48) ([mcelicalderon](https://github.com/mcelicalderon))

## [v0.8.0](https://github.com/graphql-devise/graphql_devise/tree/v0.8.0) (2019-11-26)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.7.0...v0.8.0)

**Breaking changes:**

- Set standard to use authenticatable per Devise's coding standard. [\#46](https://github.com/graphql-devise/graphql_devise/pull/46) ([aarona](https://github.com/aarona))

## [v0.7.0](https://github.com/graphql-devise/graphql_devise/tree/v0.7.0) (2019-11-25)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.6.0...v0.7.0)

**Implemented enhancements:**

- Added ResendConfirmation GraphQL method. [\#35](https://github.com/graphql-devise/graphql_devise/pull/35) ([aarona](https://github.com/aarona))

**Fixed bugs:**

- Add missing localized messages [\#41](https://github.com/graphql-devise/graphql_devise/pull/41) ([mcelicalderon](https://github.com/mcelicalderon))

## [v0.6.0](https://github.com/graphql-devise/graphql_devise/tree/v0.6.0) (2019-10-30)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.5.0...v0.6.0)

**Breaking changes:**

- Change send password reset operation name [\#32](https://github.com/graphql-devise/graphql_devise/pull/32) ([mcelicalderon](https://github.com/mcelicalderon))

## [v0.5.0](https://github.com/graphql-devise/graphql_devise/tree/v0.5.0) (2019-10-24)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.4.1...v0.5.0)

**Implemented enhancements:**

- Add routes generator [\#22](https://github.com/graphql-devise/graphql_devise/pull/22) ([00dav00](https://github.com/00dav00))

## [v0.4.1](https://github.com/graphql-devise/graphql_devise/tree/v0.4.1) (2019-10-18)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.4.0...v0.4.1)

**Fixed bugs:**

- NoMethodError generate\_confirmation\_token! but not supporting confirmable [\#24](https://github.com/graphql-devise/graphql_devise/issues/24)
- Refactor signUp mutation, fix confirmable disabled [\#26](https://github.com/graphql-devise/graphql_devise/pull/26) ([mcelicalderon](https://github.com/mcelicalderon))

**Merged pull requests:**

- Grammar fixes in README.md documentation. [\#23](https://github.com/graphql-devise/graphql_devise/pull/23) ([aarona](https://github.com/aarona))

## [v0.4.0](https://github.com/graphql-devise/graphql_devise/tree/v0.4.0) (2019-10-14)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.3.0...v0.4.0)

**Implemented enhancements:**

- Support `skip` and `only` when mounting routes [\#19](https://github.com/graphql-devise/graphql_devise/pull/19) ([mcelicalderon](https://github.com/mcelicalderon))

## [v0.3.0](https://github.com/graphql-devise/graphql_devise/tree/v0.3.0) (2019-10-04)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.2.0...v0.3.0)

**Breaking changes:**

- Use new dir for email templates [\#17](https://github.com/graphql-devise/graphql_devise/pull/17) ([mcelicalderon](https://github.com/mcelicalderon))

**Fixed bugs:**

- Fix separate resource mounts [\#16](https://github.com/graphql-devise/graphql_devise/pull/16) ([mcelicalderon](https://github.com/mcelicalderon))

## [v0.2.0](https://github.com/graphql-devise/graphql_devise/tree/v0.2.0) (2019-09-16)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.1.1...v0.2.0)

**Implemented enhancements:**

- Create user confirmation query [\#13](https://github.com/graphql-devise/graphql_devise/pull/13) ([00dav00](https://github.com/00dav00))
- Send password reset email [\#12](https://github.com/graphql-devise/graphql_devise/pull/12) ([mcelicalderon](https://github.com/mcelicalderon))
- Check reset password token mutation [\#10](https://github.com/graphql-devise/graphql_devise/pull/10) ([mcelicalderon](https://github.com/mcelicalderon))
- Update password mutation [\#9](https://github.com/graphql-devise/graphql_devise/pull/9) ([mcelicalderon](https://github.com/mcelicalderon))
- Return errors using new GraphQL specification [\#8](https://github.com/graphql-devise/graphql_devise/pull/8) ([mcelicalderon](https://github.com/mcelicalderon))
- Create sign up mutation [\#7](https://github.com/graphql-devise/graphql_devise/pull/7) ([00dav00](https://github.com/00dav00))

## [v0.1.1](https://github.com/graphql-devise/graphql_devise/tree/v0.1.1) (2019-08-30)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/27b8d31e34d63ecffc122b30e2f9b04e87509b54...v0.1.1)

**Implemented enhancements:**

- Take custom mutations when mounting gem in routes [\#5](https://github.com/graphql-devise/graphql_devise/pull/5) ([mcelicalderon](https://github.com/mcelicalderon))
- Cleanup login mutation [\#3](https://github.com/graphql-devise/graphql_devise/pull/3) ([mcelicalderon](https://github.com/mcelicalderon))
- PoC first login mutation [\#2](https://github.com/graphql-devise/graphql_devise/pull/2) ([mcelicalderon](https://github.com/mcelicalderon))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
