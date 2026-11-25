---
name: claude-disclosure-security-skill
description: Assess unintended exposure of routes, diagnostics, metadata, schemas, and operational information.
---

# DISCLOSURE security assessment

Assess unintended exposure of routes, diagnostics, metadata, schemas, and operational information.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **DISCLOSURE** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** Sensitive data (credentials, PII, internal source, infrastructure details) is retrievable by an unauthorized party without first exploiting a separate vulnerability.
- **False positive when:** The data is already public or intended for the requesting role, or reaching it required an unrelated, already-exploited foothold.

## Prompt catalog

### 261. Backup / config files

- **Difficulty:** EASY
- **Slug:** `backup-config-files`
- **Source prompt:** Brute force `.git/`, `.env`, `web.config`, `.DS_Store`, `wp-config.php.bak`, `database.yml`, `id_rsa`.

### 262. Verbose error stack traces

- **Difficulty:** EASY
- **Slug:** `verbose-error-stack-traces`
- **Source prompt:** Trigger errors with malformed inputs. Report stack traces leaking framework, paths, queries.
- **Steps:**
  1. Trigger errors with malformed inputs.
  2. Report stack traces leaking framework, paths, queries.

### 263. Debug endpoints

- **Difficulty:** EASY
- **Slug:** `debug-endpoints`
- **Source prompt:** Check `/debug`, `/actuator/*` (Spring), `/_status`, `/swagger`, `/api-docs`, `/graphql`, `/server-status` (Apache), `/server-info`.

### 264. .git repository exposed

- **Difficulty:** MED
- **Slug:** `git-repository-exposed`
- **Source prompt:** Hit `/.git/HEAD`, `/.git/config`. If 200, dump entire repo with `git-dumper`.
- **Steps:**
  1. Hit `/.git/HEAD`, `/.git/config`.
  2. If 200, dump entire repo with `git-dumper`.

### 265. Source map exposure

- **Difficulty:** EASY
- **Slug:** `source-map-exposure`
- **Source prompt:** Fetch `*.js.map` from CDN. Reconstruct original TS/JSX. Report leaked keys/logic.
- **Steps:**
  1. Fetch `*.js.map` from CDN.
  2. Reconstruct original TS/JSX.
  3. Report leaked keys/logic.

### 266. PII in logs / responses

- **Difficulty:** MED
- **Slug:** `pii-in-logs-responses`
- **Source prompt:** Audit responses for internal IDs, emails of unrelated users, full names, billing addresses.

### 267. API tokens in JS bundles

- **Difficulty:** EASY
- **Slug:** `api-tokens-in-js-bundles`
- **Source prompt:** Grep `bundle.js`, `chunk.*.js` for `AKIA`, `sk_live_`, `xoxb-`, `eyJ` (JWT), Stripe/Slack/Sendgrid patterns.

### 268. Email enumeration via timing

- **Difficulty:** MED
- **Slug:** `email-enumeration-via-timing`
- **Source prompt:** Time login responses for valid vs invalid emails — even when message is generic, RTT differs.

### 299. robots.txt / sitemap leak

- **Difficulty:** EASY
- **Slug:** `robots-txt-sitemap-leak`
- **Source prompt:** Fetch `/robots.txt`, `/sitemap.xml`, `/humans.txt`. Note disallowed paths — often pointers to admin/dev endpoints.
- **Steps:**
  1. Fetch `/robots.txt`, `/sitemap.xml`, `/humans.txt`.
  2. Note disallowed paths — often pointers to admin/dev endpoints.

### 300. GraphiQL / Apollo Studio exposed

- **Difficulty:** EASY
- **Slug:** `graphiql-apollo-studio-exposed`
- **Source prompt:** Probe `/graphiql`, `/playground`, `/altair`. Report if reachable in prod.
- **Steps:**
  1. Probe `/graphiql`, `/playground`, `/altair`.
  2. Report if reachable in prod.

## Additional web checks: source and build artifacts

Check current asset manifests and JavaScript bundles for source maps, API specifications, build
metadata, debug routes, and accidentally published configuration files. Re-resolve content-hashed
asset names during verification; an old 404 does not prove a redeploy fixed exposure. Treat `.env`,
`.git`, private source maps, and secrets as sensitive: confirm presence with minimal reads, redact
all values, and never clone or exfiltrate production history.

Useful discovery surfaces include `asset-manifest.json`, framework static directories, OpenAPI
variants, `robots.txt`, `sitemap.xml`, and build/version endpoints. Report only the minimum
necessary evidence and rotate any exposed credential through the owner.
