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

## Licence

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).