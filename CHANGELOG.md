# Changelog

## 2.1.3

* Update dependencies

## 2.1.2

* Test against Ruby 4.0

## 2.1.1

* Add optional `base_path` argument to `GovukConditionalContentItemLoader`, allowing a different path from the original request to be retrieved.
* Update dependencies

## 2.1.0

* Drop support for Ruby 3.2

## 2.0.1

* Add `stub_conditional_content_loader_isnt_available` test helper.
* Add `stub_conditional_content_loader_has_gone_item` test helper.

## 2.0.0

* BREAKING: replaces `stub_conditional_loader_returns_content_item` test helper with `stub_conditional_loader_returns_content_item_for_path` to match requests to a specific request path, for testing in frontend applications.
* BREAKING: replaces `stub_conditional_loader_does_not_return_content_item` test helper with `stub_conditional_loader_does_not_return_content_item_for_path` to match requests to a specific request path, for testing in frontend applications.

## 1.2.2

* Update dependencies

## 1.2.1

* Stub the requests in test helpers and add Plek as dependency

## 1.2.0

* Add test helpers which provide stubs

## 1.1.2

* Update dependencies

## 1.1.1

* Update dependencies

## 1.1.0

- Add Content Store fallback for failed Graphql requests

## 1.0.0

- Add GraphQL traffic rates initializer.
- Add request-level conditional content item loader for GraphQL traffic routing with `load` and `can_load_from_graphql?` methods.

## 0.1.0

Initial release
