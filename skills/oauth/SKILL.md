---
name: claude-oauth-security-skill
description: Assess OAuth and OpenID Connect flows for redirect, state, token, and client-validation weaknesses.
---

# OAUTH security assessment

Assess OAuth and OpenID Connect flows for redirect, state, token, and client-validation weaknesses.

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

Use the prompts below to guide a focused **OAUTH** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Prompt catalog

### 224. OAuth `redirect_uri` open redirect

- **Difficulty:** HARD
- **Slug:** `oauth-redirect-uri-open-redirect`
- **Source prompt:** Test `redirect_uri` for path traversal, subdomain wildcards, fragment overrides.

### 225. OAuth state missing / weak

- **Difficulty:** MED
- **Slug:** `oauth-state-missing-weak`
- **Source prompt:** Confirm `state` is sent, validated, and bound to session. CSRF the callback if not.

### 226. OAuth scope upgrade

- **Difficulty:** MED
- **Slug:** `oauth-scope-upgrade`
- **Source prompt:** Manipulate `scope` in authorize request — request scopes beyond UI offering.

### 227. Authorization code reuse

- **Difficulty:** MED
- **Slug:** `authorization-code-reuse`
- **Source prompt:** Capture the code, complete exchange, then replay the code.

### 228. Code leak via referer

- **Difficulty:** MED
- **Slug:** `code-leak-via-referer`
- **Source prompt:** If callback page loads third-party resources, the `Referer` may leak the code.

### 229. PKCE downgrade

- **Difficulty:** HARD
- **Slug:** `pkce-downgrade`
- **Source prompt:** On mobile/SPA flows, test if PKCE is enforced — try omitting `code_verifier`.

### 230. Account linking ATO

- **Difficulty:** HARD
- **Slug:** `account-linking-ato`
- **Source prompt:** Link attacker OAuth account to victim's app account via mismatched email verification.

### 231. Implicit flow token in URL

- **Difficulty:** MED
- **Slug:** `implicit-flow-token-in-url`
- **Source prompt:** If `response_type=token`, tokens land in URL — log/referer leaks.

## Source attribution

- Source: [https://hackwithclaude.com/prompts](https://hackwithclaude.com/prompts)
- Retrieved: 2026-08-28
- Included prompts: 8
