---
name: claude-graphql-security-skill
description: Assess GraphQL schema exposure, resolver authorization, query abuse, and transport behavior.
---

# GRAPHQL security assessment

Assess GraphQL schema exposure, resolver authorization, query abuse, and transport behavior.

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

Use the prompts below to guide a focused **GRAPHQL** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Prompt catalog

### 198. Introspection in prod

- **Difficulty:** EASY
- **Slug:** `introspection-in-prod`
- **Source prompt:** POST `{__schema{types{name fields{name}}}}` to `/graphql`. Save schema.

### 199. Field-level authz

- **Difficulty:** MED
- **Slug:** `field-level-authz`
- **Source prompt:** For every query/mutation, test as low-priv user. Many apps gate root resolvers but not nested fields.

### 200. Alias abuse for rate-limit bypass

- **Difficulty:** MED
- **Slug:** `alias-abuse-for-rate-limit-bypass`
- **Source prompt:** Send `{a:login(...) b:login(...) c:login(...)}` to bypass per-mutation throttling.

### 201. Mutation enumeration

- **Difficulty:** MED
- **Slug:** `mutation-enumeration`
- **Source prompt:** Even with introspection off, dictionary-attack mutation names (`createUser`, `setRole`).

### 202. GraphQL CSRF via GET

- **Difficulty:** MED
- **Slug:** `graphql-csrf-via-get`
- **Source prompt:** If GraphQL accepts GET with query param, mutations can be CSRF'd.

### 203. Batch query for IDOR

- **Difficulty:** MED
- **Slug:** `batch-query-for-idor`
- **Source prompt:** Send batch queries each with different IDs, bypassing per-request rate limits or logging.

## Source attribution

- Source: [https://hackwithclaude.com/prompts](https://hackwithclaude.com/prompts)
- Retrieved: 2026-08-28
- Included prompts: 6
