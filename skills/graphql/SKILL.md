---
name: claude-graphql-security-skill
description: Assess GraphQL schema exposure, resolver authorization, query abuse, and transport behavior.
---

# GRAPHQL security assessment

Assess GraphQL schema exposure, resolver authorization, query abuse, and transport behavior.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **GRAPHQL** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** Introspection, batching, or a resolver lets a caller bypass REST-equivalent authorization or exhaust resources beyond documented limits.
- **False positive when:** Introspection is enabled but exposes nothing beyond the already-public schema, or query depth/complexity limits do block the attempted query.

## Prompt catalog

### 198. Introspection in prod

- **Difficulty:** EASY
- **Slug:** `introspection-in-prod`
- **Source prompt:** POST `{__schema{types{name fields{name}}}}` to `/graphql`. Save schema.
- **Steps:**
  1. POST `{__schema{types{name fields{name}}}}` to `/graphql`.
  2. Save schema.

### 199. Field-level authz

- **Difficulty:** MED
- **Slug:** `field-level-authz`
- **Source prompt:** For every query/mutation, test as low-priv user. Many apps gate root resolvers but not nested fields.
- **Steps:**
  1. For every query/mutation, test as low-priv user.
  2. Many apps gate root resolvers but not nested fields.

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
