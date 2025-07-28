# Changelog

## [v2.1.0](https://github.com/graphql-devise/graphql_devise/tree/v2.1.0) (2025-07-28)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v2.0.0...v2.1.0)

**Implemented enhancements:**

- Add graphql 2.5 support [\#288](https://github.com/graphql-devise/graphql_devise/pull/288) ([mcelicalderon](https://github.com/mcelicalderon))
- Add Rails 8.0 support [\#287](https://github.com/graphql-devise/graphql_devise/pull/287) ([mcelicalderon](https://github.com/mcelicalderon))

## [v2.0.0](https://github.com/graphql-devise/graphql_devise/tree/v2.0.0) (2024-12-10)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v1.5.0...v2.0.0)

**Breaking changes:**

- Drop support for Rails \< 6.0 and Ruby \< 2.7 [\#276](https://github.com/graphql-devise/graphql_devise/pull/276) ([HeyNonster](https://github.com/HeyNonster))

**Implemented enhancements:**

- Add support for GraphQL 2.4 [\#281](https://github.com/graphql-devise/graphql_devise/pull/281) ([mcelicalderon](https://github.com/mcelicalderon))
- Test with Ruby 3.2 and 3.3 [\#279](https://github.com/graphql-devise/graphql_devise/pull/279) ([mcelicalderon](https://github.com/mcelicalderon))
- Add support for Rails 7.2 [\#278](https://github.com/graphql-devise/graphql_devise/pull/278) ([mcelicalderon](https://github.com/mcelicalderon))

## [v1.5.0](https://github.com/graphql-devise/graphql_devise/tree/v1.5.0) (2024-05-16)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v1.4.0...v1.5.0)

**Implemented enhancements:**

- Add support for graphql 2.2 and 2.3 [\#271](https://github.com/graphql-devise/graphql_devise/pull/271) ([00dav00](https://github.com/00dav00))
- Support Rails 7.1 [\#267](https://github.com/graphql-devise/graphql_devise/pull/267) ([mcelicalderon](https://github.com/mcelicalderon))

## [v1.4.0](https://github.com/graphql-devise/graphql_devise/tree/v1.4.0) (2023-10-30)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v1.3.0...v1.4.0)

**Implemented enhancements:**

- Add ability to customize raise\_user\_error\_list method [\#262](https://github.com/graphql-devise/graphql_devise/issues/262)
- Allow defining a custom raise\_user\_error\_list method [\#263](https://github.com/graphql-devise/graphql_devise/pull/263) ([mcelicalderon](https://github.com/mcelicalderon))
- Create pt-BR.yml [\#260](https://github.com/graphql-devise/graphql_devise/pull/260) ([celsoMartins](https://github.com/celsoMartins))

## [v1.3.0](https://github.com/graphql-devise/graphql_devise/tree/v1.3.0) (2023-09-01)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v1.2.0...v1.3.0)

**Implemented enhancements:**

- Support graphql v2.1 [\#257](https://github.com/graphql-devise/graphql_devise/pull/257) ([mcelicalderon](https://github.com/mcelicalderon))

## [v1.2.0](https://github.com/graphql-devise/graphql_devise/tree/v1.2.0) (2022-11-21)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v1.1.1...v1.2.0)

**Implemented enhancements:**

- Set base controller from route mount [\#237](https://github.com/graphql-devise/graphql_devise/pull/237) ([00dav00](https://github.com/00dav00))

## [v1.1.1](https://github.com/graphql-devise/graphql_devise/tree/v1.1.1) (2022-10-20)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v1.1.0...v1.1.1)

**Fixed bugs:**

- Cannot make it work with Mongoid [\#244](https://github.com/graphql-devise/graphql_devise/issues/244)
- Fix Mongoid Support [\#245](https://github.com/graphql-devise/graphql_devise/pull/245) ([jpmermoz](https://github.com/jpmermoz))

## [v1.1.0](https://github.com/graphql-devise/graphql_devise/tree/v1.1.0) (2022-09-15)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v1.0.1...v1.1.0)

**Implemented enhancements:**

- Support Rails 7 [\#241](https://github.com/graphql-devise/graphql_devise/pull/241) ([mcelicalderon](https://github.com/mcelicalderon))

**Merged pull requests:**

- Fix typo in README file.  [\#238](https://github.com/graphql-devise/graphql_devise/pull/238) ([MathiasPfeil](https://github.com/MathiasPfeil))

## [v1.0.1](https://github.com/graphql-devise/graphql_devise/tree/v1.0.1) (2022-08-15)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v1.0.0...v1.0.1)

**Fixed bugs:**

- A class must be provided when mounting a model. String values are no longer supported [\#235](https://github.com/graphql-devise/graphql_devise/issues/235)
- Use the class itself in the route generator instead of a string representation [\#236](https://github.com/graphql-devise/graphql_devise/pull/236) ([whotwagner](https://github.com/whotwagner))
- Honor dta auth cookie when using the schema plugin in a main rails project route [\#233](https://github.com/graphql-devise/graphql_devise/pull/233) ([00dav00](https://github.com/00dav00))

## [v1.0.0](https://github.com/graphql-devise/graphql_devise/tree/v1.0.0) (2022-08-04)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.18.2...v1.0.0)

**Breaking changes:**

- Remove deprecated model and controller concerns [\#214](https://github.com/graphql-devise/graphql_devise/pull/214) ([mcelicalderon](https://github.com/mcelicalderon))
- Load reqs with zeitwerk \(drop ruby 2.3 support\) [\#209](https://github.com/graphql-devise/graphql_devise/pull/209) ([00dav00](https://github.com/00dav00))
- Remove deprecated authentication methods [\#199](https://github.com/graphql-devise/graphql_devise/pull/199) ([mcelicalderon](https://github.com/mcelicalderon))
- Remove all deprecated queries before v1.0 release [\#198](https://github.com/graphql-devise/graphql_devise/pull/198) ([mcelicalderon](https://github.com/mcelicalderon))
- Drop support for ruby 2.2 [\#197](https://github.com/graphql-devise/graphql_devise/pull/197) ([mcelicalderon](https://github.com/mcelicalderon))

**Implemented enhancements:**

- Add GraphQL 2 support [\#222](https://github.com/graphql-devise/graphql_devise/pull/222) ([mcelicalderon](https://github.com/mcelicalderon))
- Add support for graphql 1.13 [\#205](https://github.com/graphql-devise/graphql_devise/pull/205) ([mcelicalderon](https://github.com/mcelicalderon))

**Closed issues:**

- Uninitialized constant GraphqlDevise [\#216](https://github.com/graphql-devise/graphql_devise/issues/216)

**Merged pull requests:**

- Remove deprecations from docs before v1 release [\#201](https://github.com/graphql-devise/graphql_devise/pull/201) ([mcelicalderon](https://github.com/mcelicalderon))

## [v0.18.2](https://github.com/graphql-devise/graphql_devise/tree/v0.18.2) (2022-03-09)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.18.1...v0.18.2)

**Implemented enhancements:**

- Silence graphql\_definition deprecation warning before suporting GQL 2.0 [\#217](https://github.com/graphql-devise/graphql_devise/pull/217) ([janraasch](https://github.com/janraasch))

## [v0.18.1](https://github.com/graphql-devise/graphql_devise/tree/v0.18.1) (2022-03-06)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.18.0...v0.18.1)

**Deprecated:**

- Deprecate model and controller concerns. Provide new versions [\#213](https://github.com/graphql-devise/graphql_devise/pull/213) ([mcelicalderon](https://github.com/mcelicalderon))

## [v0.18.0](https://github.com/graphql-devise/graphql_devise/tree/v0.18.0) (2022-02-08)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.17.1...v0.18.0)

**Implemented enhancements:**

- Support GQL 1.13 [\#211](https://github.com/graphql-devise/graphql_devise/pull/211) ([mcelicalderon](https://github.com/mcelicalderon))

**Closed issues:**

- Potential Bug For MailHelper [\#144](https://github.com/graphql-devise/graphql_devise/issues/144)

## [v0.17.1](https://github.com/graphql-devise/graphql_devise/tree/v0.17.1) (2021-08-02)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.17.0...v0.17.1)

**Implemented enhancements:**

- Set context\[:current\_resource\] upon login [\#193](https://github.com/graphql-devise/graphql_devise/pull/193) ([TomasBarry](https://github.com/TomasBarry))

**Merged pull requests:**

- Improve README [\#190](https://github.com/graphql-devise/graphql_devise/pull/190) ([00dav00](https://github.com/00dav00))

## [v0.17.0](https://github.com/graphql-devise/graphql_devise/tree/v0.17.0) (2021-06-09)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.16.0...v0.17.0)

**Implemented enhancements:**

- Another click in confirm account results in error [\#184](https://github.com/graphql-devise/graphql_devise/issues/184)
- Add resendConfirmationWithToken mutation [\#186](https://github.com/graphql-devise/graphql_devise/pull/186) ([mcelicalderon](https://github.com/mcelicalderon))
- Add register mutation and alternate confirmation flow [\#185](https://github.com/graphql-devise/graphql_devise/pull/185) ([mcelicalderon](https://github.com/mcelicalderon))

**Deprecated:**

- Deprecate mutations and queries that required a redirect [\#187](https://github.com/graphql-devise/graphql_devise/pull/187) ([mcelicalderon](https://github.com/mcelicalderon))

**Merged pull requests:**

- Document new registration and confirmation flow [\#188](https://github.com/graphql-devise/graphql_devise/pull/188) ([mcelicalderon](https://github.com/mcelicalderon))

## [v0.16.0](https://github.com/graphql-devise/graphql_devise/tree/v0.16.0) (2021-05-20)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.15.0...v0.16.0)

**Implemented enhancements:**

- Allow checking of authenticaded resource via callable object [\#180](https://github.com/graphql-devise/graphql_devise/pull/180) ([mcelicalderon](https://github.com/mcelicalderon))

**Merged pull requests:**

- Document authenticate with callable [\#181](https://github.com/graphql-devise/graphql_devise/pull/181) ([mcelicalderon](https://github.com/mcelicalderon))

## [v0.15.0](https://github.com/graphql-devise/graphql_devise/tree/v0.15.0) (2021-05-09)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.14.3...v0.15.0)

**Implemented enhancements:**

- Allow controller level authentication [\#175](https://github.com/graphql-devise/graphql_devise/pull/175) ([mcelicalderon](https://github.com/mcelicalderon))

**Deprecated:**

- Deprecate authenticating resources inside the GQL schema [\#176](https://github.com/graphql-devise/graphql_devise/pull/176) ([mcelicalderon](https://github.com/mcelicalderon))

**Merged pull requests:**

- Add controller level auth documentation [\#177](https://github.com/graphql-devise/graphql_devise/pull/177) ([mcelicalderon](https://github.com/mcelicalderon))

## [v0.14.3](https://github.com/graphql-devise/graphql_devise/tree/v0.14.3) (2021-04-28)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.14.2...v0.14.3)

**Implemented enhancements:**

- Add Support for Ruby 3 [\#170](https://github.com/graphql-devise/graphql_devise/pull/170) ([00dav00](https://github.com/00dav00))

**Fixed bugs:**

- ArgumentError \(wrong number of arguments \(given 2, expected 0..1\)\) [\#169](https://github.com/graphql-devise/graphql_devise/issues/169)

## [v0.14.2](https://github.com/graphql-devise/graphql_devise/tree/v0.14.2) (2021-03-08)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.14.1...v0.14.2)

**Implemented enhancements:**

- Add config for public introspection query on schema plugin [\#154](https://github.com/graphql-devise/graphql_devise/pull/154) ([00dav00](https://github.com/00dav00))

## [v0.14.1](https://github.com/graphql-devise/graphql_devise/tree/v0.14.1) (2021-02-11)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.14.0...v0.14.1)

**Implemented enhancements:**

- Testing Authenticated Elements [\#138](https://github.com/graphql-devise/graphql_devise/issues/138)
- Add support for GraphQL 1.12 [\#150](https://github.com/graphql-devise/graphql_devise/pull/150) ([mengqing](https://github.com/mengqing))
- Allow setting current resource in tests [\#149](https://github.com/graphql-devise/graphql_devise/pull/149) ([00dav00](https://github.com/00dav00))

**Merged pull requests:**

- Document password reset flows [\#147](https://github.com/graphql-devise/graphql_devise/pull/147) ([mcelicalderon](https://github.com/mcelicalderon))

## [v0.14.0](https://github.com/graphql-devise/graphql_devise/tree/v0.14.0) (2021-01-19)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.13.6...v0.14.0)

**Implemented enhancements:**

- Alternate reset password flow, only 2 steps, no redirect [\#146](https://github.com/graphql-devise/graphql_devise/pull/146) ([mcelicalderon](https://github.com/mcelicalderon))

## [v0.13.6](https://github.com/graphql-devise/graphql_devise/tree/v0.13.6) (2020-12-22)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.13.5...v0.13.6)

**Security fixes:**

- Possible security issue with password reset and redirectUrl [\#136](https://github.com/graphql-devise/graphql_devise/issues/136)
- Add redirect whitelist validation to all queries and mutations [\#140](https://github.com/graphql-devise/graphql_devise/pull/140) ([mcelicalderon](https://github.com/mcelicalderon))

## [v0.13.5](https://github.com/graphql-devise/graphql_devise/tree/v0.13.5) (2020-11-20)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.13.4...v0.13.5)

**Implemented enhancements:**

- Fixes connection\_config deprecation warning [\#135](https://github.com/graphql-devise/graphql_devise/pull/135) ([artplan1](https://github.com/artplan1))

## [v0.13.4](https://github.com/graphql-devise/graphql_devise/tree/v0.13.4) (2020-08-16)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.13.3...v0.13.4)

**Implemented enhancements:**

- Allow resend of confirmation with unconfirmed email [\#127](https://github.com/graphql-devise/graphql_devise/pull/127) ([j15e](https://github.com/j15e))

## [v0.13.3](https://github.com/graphql-devise/graphql_devise/tree/v0.13.3) (2020-08-13)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.13.2...v0.13.3)

**Fixed bugs:**

- Fix unconfirmed\_email confirmation. Ignore devise reconfirmable config. [\#126](https://github.com/graphql-devise/graphql_devise/pull/126) ([mcelicalderon](https://github.com/mcelicalderon))

## [v0.13.2](https://github.com/graphql-devise/graphql_devise/tree/v0.13.2) (2020-08-12)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.13.1...v0.13.2)

**Fixed bugs:**

- Save resource after generating credentials in resource confirmation [\#125](https://github.com/graphql-devise/graphql_devise/pull/125) ([mcelicalderon](https://github.com/mcelicalderon))

## [v0.13.1](https://github.com/graphql-devise/graphql_devise/tree/v0.13.1) (2020-07-30)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.13.0...v0.13.1)

**Implemented enhancements:**

- Add credentials field on signUp mutation [\#122](https://github.com/graphql-devise/graphql_devise/pull/122) ([mcelicalderon](https://github.com/mcelicalderon))

**Closed issues:**

- Checking for `performed?` when mounting into your graphql schema. [\#110](https://github.com/graphql-devise/graphql_devise/issues/110)
- no query string for email reset [\#104](https://github.com/graphql-devise/graphql_devise/issues/104)

## [v0.13.0](https://github.com/graphql-devise/graphql_devise/tree/v0.13.0) (2020-06-23)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.12.3...v0.13.0)

**Breaking changes:**

- Fix email reconfirmation feature [\#111](https://github.com/graphql-devise/graphql_devise/pull/111) ([mcelicalderon](https://github.com/mcelicalderon))

**Implemented enhancements:**

- Add frozen string literal to all relevant files [\#114](https://github.com/graphql-devise/graphql_devise/pull/114) ([mcelicalderon](https://github.com/mcelicalderon))

**Fixed bugs:**

- CookieOverflow for Own Schema Mount [\#112](https://github.com/graphql-devise/graphql_devise/issues/112)
- Reconfirmable not setting unconfirmed\_email [\#102](https://github.com/graphql-devise/graphql_devise/issues/102)

## [v0.12.3](https://github.com/graphql-devise/graphql_devise/tree/v0.12.3) (2020-06-20)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.12.2...v0.12.3)

**Implemented enhancements:**

- Add support for graphql 1.11 [\#108](https://github.com/graphql-devise/graphql_devise/pull/108) ([mcelicalderon](https://github.com/mcelicalderon))

## [v0.12.2](https://github.com/graphql-devise/graphql_devise/tree/v0.12.2) (2020-06-17)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.12.1...v0.12.2)

**Breaking changes:**

- Fix set\_resource\_by\_token no mapping error in no eager load envs [\#107](https://github.com/graphql-devise/graphql_devise/pull/107) ([mcelicalderon](https://github.com/mcelicalderon))

**Fixed bugs:**

- Separate endpoint url for mailers even if mounting the gem in your own schema [\#105](https://github.com/graphql-devise/graphql_devise/issues/105)
- Devise mapping error [\#103](https://github.com/graphql-devise/graphql_devise/issues/103)
- Use the url where the schema is mounted in emails links [\#106](https://github.com/graphql-devise/graphql_devise/pull/106) ([00dav00](https://github.com/00dav00))

## [v0.12.1](https://github.com/graphql-devise/graphql_devise/tree/v0.12.1) (2020-06-12)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.12.0...v0.12.1)

**Security fixes:**

- Insecure send password reset mutation? [\#98](https://github.com/graphql-devise/graphql_devise/issues/98)
- Avoid returning user information on password reset mutation [\#100](https://github.com/graphql-devise/graphql_devise/pull/100) ([00dav00](https://github.com/00dav00))

## [v0.12.0](https://github.com/graphql-devise/graphql_devise/tree/v0.12.0) (2020-06-12)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.11.4...v0.12.0)

**Implemented enhancements:**

- Mount auth operations in main GQL schema [\#96](https://github.com/graphql-devise/graphql_devise/pull/96) ([mcelicalderon](https://github.com/mcelicalderon))

## [v0.11.4](https://github.com/graphql-devise/graphql_devise/tree/v0.11.4) (2020-05-23)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.11.3...v0.11.4)

**Implemented enhancements:**

- Do nothing if forgery protection enabled in ApplicationController [\#93](https://github.com/graphql-devise/graphql_devise/pull/93) ([mcelicalderon](https://github.com/mcelicalderon))

## [v0.11.3](https://github.com/graphql-devise/graphql_devise/tree/v0.11.3) (2020-05-23)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.11.2...v0.11.3)

**Implemented enhancements:**

- Default `change_headers_on_each_request` to false [\#76](https://github.com/graphql-devise/graphql_devise/issues/76)
- Replace the auth model concern on generator execution [\#53](https://github.com/graphql-devise/graphql_devise/issues/53)
- Generator. Use our modules, change defaults [\#91](https://github.com/graphql-devise/graphql_devise/pull/91) ([mcelicalderon](https://github.com/mcelicalderon))

## [v0.11.2](https://github.com/graphql-devise/graphql_devise/tree/v0.11.2) (2020-05-07)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.11.1...v0.11.2)

**Fixed bugs:**

- Avoid multiple schema and type load \(Devise behavior\) [\#88](https://github.com/graphql-devise/graphql_devise/pull/88) ([mcelicalderon](https://github.com/mcelicalderon))

## [v0.11.1](https://github.com/graphql-devise/graphql_devise/tree/v0.11.1) (2020-05-05)

[Full Changelog](https://github.com/graphql-devise/graphql_devise/compare/v0.11.0...v0.11.1)

**Implemented enhancements:**

- Add case insensitive fields to sign\_up and login [\#66](https://github.com/graphql-devise/graphql_devise/issues/66)
- Honor Devise's case insensitive fields [\#81](https://github.com/graphql-devise/graphql_devise/pull/81) ([mcelicalderon](https://github.com/mcelicalderon))

**Fixed bugs:**

- Add query and mutation type only once after app routes [\#87](https://github.com/graphql-devise/graphql_devise/pull/87) ([mcelicalderon](https://github.com/mcelicalderon))

**Closed issues:**

- Get the Mutations going [\#83](https://github.com/graphql-devise/graphql_devise/issues/83)
- Improve docs. Better reference to Devise and DTA. [\#75](https://github.com/graphql-devise/graphql_devise/issues/75)

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
