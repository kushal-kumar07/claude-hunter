---
name: claude-api-security-skill
description: Assess API parsing, parameter handling, method behavior, and consistency across intermediaries.
---

# API security assessment

Assess API parsing, parameter handling, method behavior, and consistency across intermediaries.

## Operating rules

- Work only against systems, applications, accounts, and repositories where explicit authorization and a defined test window exist.
- Prefer local fixtures, staging environments, synthetic records, and non-destructive canaries. Do not access, alter, exfiltrate, or persist real user data.
- Establish rate, concurrency, payload-size, and stop limits before testing. Stop immediately if availability, confidentiality, or integrity could be affected.
- Treat a suspected issue as unconfirmed until the request, response, execution/data-flow evidence, affected principal, and security impact are recorded.
- Never use weaponized payloads when a harmless marker or controlled callback can demonstrate the same behavior.
- Redact secrets and personal data in notes. Report remediation guidance and the exact authorization scope alongside findings.

## Assessment workflow

1. Define scope, identities, environment, test limits, and rollback contacts.
2. Inventory relevant endpoints, inputs, parsers, trust boundaries, and user roles.
3. Start with passive inspection and benign markers; compare behavior across roles, methods, encodings, and content types.
4. Use the category prompt catalog below as hypotheses, adapting payloads to safe canaries and the approved environment.
5. Capture reproducible evidence: timestamp, endpoint, method, sanitized request/response, actor, preconditions, observed result, and impact.
6. Validate fixes with regression tests, then document residual risk and monitoring recommendations.

## Finding format

- **Title / severity / confidence**
- **Affected asset and authorization context**
- **Preconditions and reproduction steps**
- **Sanitized evidence and source-to-sink or control-flow path**
- **Security impact and affected users/data**
- **Root cause**
- **Recommended remediation and regression test**

## Category-specific focus

Use the prompts below to guide a focused **API** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Prompt catalog

### 158. Unauthenticated API endpoint scan

- **Difficulty:** EASY
- **Slug:** `unauthenticated-api-endpoint-scan`
- **Source prompt:** Crawl the SPA bundle for API URLs. Hit each one without auth. Report 200s.

### 159. API version downgrade

- **Difficulty:** MED
- **Slug:** `api-version-downgrade`
- **Source prompt:** If `/v2/` exists, test `/v1/`, `/v0/`, `/beta/`, `/internal/` — often missing auth.

### 160. Verb tampering on REST

- **Difficulty:** EASY
- **Slug:** `verb-tampering-on-rest`
- **Source prompt:** For each endpoint, test all verbs (GET, POST, PUT, PATCH, DELETE, OPTIONS, HEAD). Diff responses.

### 161. Excessive data exposure

- **Difficulty:** EASY
- **Slug:** `excessive-data-exposure`
- **Source prompt:** Inspect API responses for fields not displayed in UI: emails, internal IDs, hashes, tokens. Report leaks.

### 162. Pagination abuse

- **Difficulty:** MED
- **Slug:** `pagination-abuse`
- **Source prompt:** Set `limit=1000000`, `limit=-1`, `offset=-1`. Report DoS or unauthorized data.

### 163. GraphQL introspection enabled

- **Difficulty:** EASY
- **Slug:** `graphql-introspection-enabled`
- **Source prompt:** POST `{__schema{types{name}}}`. Report if enabled in production.

### 164. GraphQL deep query DoS

- **Difficulty:** MED
- **Slug:** `graphql-deep-query-dos`
- **Source prompt:** Submit deeply nested queries (`user{posts{user{posts{...}}}}`) to exhaust resources.

### 165. GraphQL batching to bypass rate limits

- **Difficulty:** MED
- **Slug:** `graphql-batching-to-bypass-rate-limits`
- **Source prompt:** Send 100 queries in one POST batch. Report rate-limit bypass.

### 166. Webhook signature missing

- **Difficulty:** MED
- **Slug:** `webhook-signature-missing`
- **Source prompt:** POST to webhook endpoints with empty / missing / forged signatures. Test acceptance.

### 167. API key in URL / referer leak

- **Difficulty:** MED
- **Slug:** `api-key-in-url-referer-leak`
- **Source prompt:** Search for endpoints that accept API keys via query string. Check that referer/log/cache leaks aren't exploitable.

### 303. HTTP parameter pollution

- **Difficulty:** MED
- **Slug:** `http-parameter-pollution`
- **Source prompt:** Send `?id=1&id=2`. Different stacks pick first/last/concat — observe authz drift.

### 304. JSON parser quirks

- **Difficulty:** HARD
- **Slug:** `json-parser-quirks`
- **Source prompt:** Send duplicate keys, NaN, Infinity, `__proto__`, BOM-prefixed bodies. Report parsers that accept malformed JSON.

## Source attribution

- Source: [https://hackwithclaude.com/prompts](https://hackwithclaude.com/prompts)
- Retrieved: 2026-08-28
- Included prompts: 12

## Additional coverage

- Method override, content-type confusion, mass assignment, and API gateway/backend parser drift.
- GraphQL-to-REST authorization inconsistencies and alternate transport behavior.
- Treat validation errors as reachability clues, not authorization proof; confirm with minimal
  synthetic data.

### Source attribution

- Adapted from `SnailSploit/Claude-Red` `Skills/web/offensive-parameter-pollution/SKILL.md` and
  related web API checklist material.
- Source repository: https://github.com/SnailSploit/Claude-Red

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

### Source attribution

- Adapted from `elementalsouls/Claude-BugHunter` skills `hunt-spa-api` and `hunt-shadow-api`.
- Repository content license: CC BY 4.0.
