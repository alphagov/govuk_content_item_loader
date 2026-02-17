# ADR 1: Create a dedicated gem for conditional GraphQL content loading
Status: Accepted
Date: 2026-02-17

## Context
As part of the migration toward GraphQL-backed content retrieval, we are introducing a ConditionalContentItemLoader that determines whether a request should load content from:
* The Content Store (REST), or
* The Publishing API via GraphQL

This decision is made at request time and depends on:
* Request parameters
* Environment state (e.g. draft host)
* Allow-list configuration
* Probabilistic traffic splitting

It includes Prometheus metrics labelling for monitoring and alerting.

The loader is required across seven frontend applications.

## Problem
We need a centralised implementation to:
* Avoid duplication and divergence across multiple apps
* Maintain clear architectural boundaries
* Keep configuration and routing logic co-located

## Decision
We will create a Ruby gem to encapsulate the conditional content loader and its configuration, with minimal dependencies.

## Rationale
1. Shared across multiple applications
One gem ensures consistent behaviour and easier rollout coordination.

1. Maintenance burden is acceptable
The gem is small, with few dependencies.

1. Not a good fit for `gds-api-adapters`
`gds-api-adapters` is designed around a clear architectural pattern:
* Each adapter corresponds to a single external API
* Adapter methods map directly to HTTP endpoints
* Namespaces reflect a 1:1 relationship with APIs

The conditional loader does not fit this model as it's a higher-level orchestration layer, not a client abstraction. Adding it to gds-api-adapters would:
* Blur architectural boundaries
* Violate separation of concerns
* Break the established software design pattern of the gem

1. Not a good fit for `govuk_app_config`
That library is intended for generic application configuration, not behaviour orchestration used by a subset of apps.

1. Explicitly not using `govuk_ab_testing`
`govuk_ab_testing` was considered. This is not a generic A/B test or experiment framework use case. Embedding this logic in govuk_ab_testing would conflate experimentation infrastructure with migration routing logic.

1. Co-location with configuration
The loader depends on configuration established via GovukGraphqlTrafficRates.configure which would fit in govuk_app_config. However, keeping it in the same gem reduces complexity and risk of misconfiguration. 

## Alternatives considered
- Duplicate in each app – rejected due to divergence risk.
- Add to `gds-api-adapters` – rejected; violates separation of concerns.
- Add to `govuk_app_config` – rejected; not just application configuration.
- Add to `govuk_ab_testing` – rejected; not experimentation logic.

## Consequences

### Positive
* Consistent behaviour across multiple applications
* Clean architectural separation
* Centralised rollout
* Clear ownership of GraphQL migration logic
* Versioned upgrades

### Negative
* One additional gem to maintain
* Increase in dependency management overhead