# GOV.UK Content Item Loader

Ruby gem that standardises how GOV.UK frontend apps load content items. It provides configurable GraphQL traffic rates per content schema and a request-level loader that routes requests to the Publishing API via GraphQL or falls back to the Content Store ensuring consistent traffic management across applications.

## Installation

Install the gem

    `gem install govuk_content_item_loader`

or add it to your Gemfile

    `gem "govuk_content_item_loader"`

## GraphQL traffic rates

Provides a canonical way for frontend apps to configure GraphQL traffic rates for relevant content schemas. It sets the following application configuration:

* `Rails.application.config.graphql_allowed_schemas` - array of schema names that are eligible to be served via GraphQL.
* `Rails.application.config.graphql_traffic_rates` - hash mapping schema names to traffic percentages (as floats between 0 and 1.0).

Traffic rates for individual schemas are set in `govuk-helm-charts` repository as environment variables, with the following format `GRAPHQL_RATE_<SCHEMA_NAME>`.

### Usage

To enable this functionality, create a file `config/initializers/govuk_graphql_traffic_rates.rb` in the app containing:

```ruby
GovukGraphqlTrafficRates.configure
```

## Conditional Content Item Loader

This class acts as a traffic-splitting content loader that decides, per request, whether to fetch a content item from the **Publishing API via GraphQL** or fall back to the **Content Store**, based on request parameters and configured traffic-shaping rules based on content schemas.

**In practice, it:**

* Chooses between GraphQL (Publishing API) and the Content Store when loading a content item
* Always disables GraphQL on draft hosts
* Allows GraphQL to be explicitly forced on or off via the `graphql` request parameter
* Falls back to the Content Store unless the content item’s schema is explicitly allow-listed
* Uses a per-schema traffic rate to probabilistically route a percentage of requests to GraphQL
* Records GraphQL success, error status codes and timeouts in Prometheus request labels
* Propagates GdsApi errors

### Usage 

#### Prerequisites

1. Ensure application configuration sets list of schema names that are eligible to be served via GraphQL and hash mapping schema names to traffic percentages via `GovukGraphqlTrafficRates` described above.

2. Ensure the `PLEK_SERVICE_PUBLISHING_API_URI` environment variable is set in **govuk-helm-charts** for the live app (draft stack is handled via [`PLEK_HOSTNAME_PREFIX`](https://github.com/alphagov/plek/blob/main/CHANGELOG.md#410)), across all relevant environments, so the Publishing API (GraphQL) can be correctly resolved at runtime:

  ```yaml
  - name: PLEK_SERVICE_PUBLISHING_API_URI
    value: "http://publishing-api-read-replica"
  ```

3. (Assumed true for all frontend apps) Ensure the application has Content Store connection configuration.

#### Using the loader

`GovukConditionalContentItemLoader` is intended to be used at the point where a request needs to load a content item, and where traffic may be conditionally routed to GraphQL instead of the Content Store.

At its simplest, you initialise the loader with the current request and call load:
```
loader = GovukConditionalContentItemLoader.new(request: request)
content_item = loader.load
```

By default, the loader uses:
* `GdsApi.content_store` to fetch content from the Content Store
* `GdsApi.publishing_api` to fetch content via GraphQL

These defaults make it suitable for use in production code without additional configuration.

*Passing custom clients*
For testing or specialised use cases, you can explicitly pass in the API clients:
```
loader = GovukGraphql::ConditionalContentItemLoader.new(
  request: request,
  content_store_client: content_store_client,
  publishing_api_client: publishing_api_client,
)
```

The decision logic is also exposed via `can_load_from_graphql?`, allowing applications to make the routing decision themselves and implement custom fallback or error-handling behaviour if needed.

## Licence

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).