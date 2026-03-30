# Changelog

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
