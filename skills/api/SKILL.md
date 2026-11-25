---
name: claude-api-security-skill
description: Assess API parsing, parameter handling, method behavior, and consistency across intermediaries.
---

# API security assessment

Assess API parsing, parameter handling, method behavior, and consistency across intermediaries.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **API** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** An endpoint accepts a parameter, method, version, or data shape the documented contract disallows, and this changes an authorization outcome or exposes undocumented fields.
- **False positive when:** The unexpected input still returns a validation error that blocks the action, or behavior is identical across versions with no security-relevant difference.

## Prompt catalog

### 158. Unauthenticated API endpoint scan

- **Difficulty:** EASY
- **Slug:** `unauthenticated-api-endpoint-scan`
- **Source prompt:** Crawl the SPA bundle for API URLs. Hit each one without auth. Report 200s.
- **Steps:**
  1. Crawl the SPA bundle for API URLs.
  2. Hit each one without auth.
  3. Report 200s.

### 159. API version downgrade

- **Difficulty:** MED
- **Slug:** `api-version-downgrade`
- **Source prompt:** If `/v2/` exists, test `/v1/`, `/v0/`, `/beta/`, `/internal/` — often missing auth.

### 160. Verb tampering on REST

- **Difficulty:** EASY
- **Slug:** `verb-tampering-on-rest`
- **Source prompt:** For each endpoint, test all verbs (GET, POST, PUT, PATCH, DELETE, OPTIONS, HEAD). Diff responses.
- **Steps:**
  1. For each endpoint, test all verbs (GET, POST, PUT, PATCH, DELETE, OPTIONS, HEAD).
  2. Diff responses.

### 161. Excessive data exposure

- **Difficulty:** EASY
- **Slug:** `excessive-data-exposure`
- **Source prompt:** Inspect API responses for fields not displayed in UI: emails, internal IDs, hashes, tokens. Report leaks.
- **Steps:**
  1. Inspect API responses for fields not displayed in UI: emails, internal IDs, hashes, tokens.
  2. Report leaks.

### 162. Pagination abuse

- **Difficulty:** MED
- **Slug:** `pagination-abuse`
- **Source prompt:** Set `limit=1000000`, `limit=-1`, `offset=-1`. Report DoS or unauthorized data.
- **Steps:**
  1. Set `limit=1000000`, `limit=-1`, `offset=-1`.
  2. Report DoS or unauthorized data.

### 163. GraphQL introspection enabled

- **Difficulty:** EASY
- **Slug:** `graphql-introspection-enabled`
- **Source prompt:** POST `{__schema{types{name}}}`. Report if enabled in production.
- **Steps:**
  1. POST `{__schema{types{name}}}`.
  2. Report if enabled in production.

### 164. GraphQL deep query DoS

- **Difficulty:** MED
- **Slug:** `graphql-deep-query-dos`
- **Source prompt:** Submit deeply nested queries (`user{posts{user{posts{...}}}}`) to exhaust resources.

### 165. GraphQL batching to bypass rate limits

- **Difficulty:** MED
- **Slug:** `graphql-batching-to-bypass-rate-limits`
- **Source prompt:** Send 100 queries in one POST batch. Report rate-limit bypass.
- **Steps:**
  1. Send 100 queries in one POST batch.
  2. Report rate-limit bypass.

### 166. Webhook signature missing

- **Difficulty:** MED
- **Slug:** `webhook-signature-missing`
- **Source prompt:** POST to webhook endpoints with empty / missing / forged signatures. Test acceptance.
- **Steps:**
  1. POST to webhook endpoints with empty / missing / forged signatures.
  2. Test acceptance.

### 167. API key in URL / referer leak

- **Difficulty:** MED
- **Slug:** `api-key-in-url-referer-leak`
- **Source prompt:** Search for endpoints that accept API keys via query string. Check that referer/log/cache leaks aren't exploitable.
- **Steps:**
  1. Search for endpoints that accept API keys via query string.
  2. Check that referer/log/cache leaks aren't exploitable.

### 303. HTTP parameter pollution

- **Difficulty:** MED
- **Slug:** `http-parameter-pollution`
- **Source prompt:** Send `?id=1&id=2`. Different stacks pick first/last/concat — observe authz drift.
- **Steps:**
  1. Send `?id=1&id=2`.
  2. Different stacks pick first/last/concat — observe authz drift.

### 304. JSON parser quirks

- **Difficulty:** HARD
- **Slug:** `json-parser-quirks`
- **Source prompt:** Send duplicate keys, NaN, Infinity, `__proto__`, BOM-prefixed bodies. Report parsers that accept malformed JSON.
- **Steps:**
  1. Send duplicate keys, NaN, Infinity, `__proto__`, BOM-prefixed bodies.
  2. Report parsers that accept malformed JSON.

## Additional coverage

- Method override, content-type confusion, mass assignment, and API gateway/backend parser drift.
- GraphQL-to-REST authorization inconsistencies and alternate transport behavior.
- Treat validation errors as reachability clues, not authorization proof; confirm with minimal
  synthetic data.

## Additional web checks

### SPA route discovery

For authorized targets, inventory HTML-referenced and lazy-loaded JavaScript chunks, extract API
hosts and route families, then establish a protected control endpoint before testing discovered
routes without authentication. A `400` that proves business validation ran is a lead, not proof;
confirm with the minimum harmless request and stop after minimal synthetic data.

### Shadow and zombie APIs

Enumerate path-, header-, and subdomain-versioned APIs, archived OpenAPI specifications, and
deprecated routes. Behaviorally compare old and current versions for authorization, rate limiting,
input validation, and field exposure. A live old route is not itself a vulnerability; the finding
is a security regression or unintended sensitive exposure.
