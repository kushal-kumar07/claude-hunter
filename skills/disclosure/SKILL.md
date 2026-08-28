---
name: claude-disclosure-security-skill
description: Assess unintended exposure of routes, diagnostics, metadata, schemas, and operational information.
---

# DISCLOSURE security assessment

Assess unintended exposure of routes, diagnostics, metadata, schemas, and operational information.

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

Use the prompts below to guide a focused **DISCLOSURE** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Prompt catalog

### 261. Backup / config files

- **Difficulty:** EASY
- **Slug:** `backup-config-files`
- **Source prompt:** Brute force `.git/`, `.env`, `web.config`, `.DS_Store`, `wp-config.php.bak`, `database.yml`, `id_rsa`.

### 262. Verbose error stack traces

- **Difficulty:** EASY
- **Slug:** `verbose-error-stack-traces`
- **Source prompt:** Trigger errors with malformed inputs. Report stack traces leaking framework, paths, queries.

### 263. Debug endpoints

- **Difficulty:** EASY
- **Slug:** `debug-endpoints`
- **Source prompt:** Check `/debug`, `/actuator/*` (Spring), `/_status`, `/swagger`, `/api-docs`, `/graphql`, `/server-status` (Apache), `/server-info`.

### 264. .git repository exposed

- **Difficulty:** MED
- **Slug:** `git-repository-exposed`
- **Source prompt:** Hit `/.git/HEAD`, `/.git/config`. If 200, dump entire repo with `git-dumper`.

### 265. Source map exposure

- **Difficulty:** EASY
- **Slug:** `source-map-exposure`
- **Source prompt:** Fetch `*.js.map` from CDN. Reconstruct original TS/JSX. Report leaked keys/logic.

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

### 300. GraphiQL / Apollo Studio exposed

- **Difficulty:** EASY
- **Slug:** `graphiql-apollo-studio-exposed`
- **Source prompt:** Probe `/graphiql`, `/playground`, `/altair`. Report if reachable in prod.

## Source attribution

- Source: [https://hackwithclaude.com/prompts](https://hackwithclaude.com/prompts)
- Retrieved: 2026-08-28
- Included prompts: 10

## Additional web checks: source and build artifacts

Check current asset manifests and JavaScript bundles for source maps, API specifications, build
metadata, debug routes, and accidentally published configuration files. Re-resolve content-hashed
asset names during verification; an old 404 does not prove a redeploy fixed exposure. Treat `.env`,
`.git`, private source maps, and secrets as sensitive: confirm presence with minimal reads, redact
all values, and never clone or exfiltrate production history.

Useful discovery surfaces include `asset-manifest.json`, framework static directories, OpenAPI
variants, `robots.txt`, `sitemap.xml`, and build/version endpoints. Report only the minimum
necessary evidence and rotate any exposed credential through the owner.

### Source attribution

- Adapted from `elementalsouls/Claude-BugHunter` `skills/hunt-source-leak/SKILL.md`.
- Repository content license: CC BY 4.0.
