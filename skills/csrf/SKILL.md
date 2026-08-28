---
name: claude-csrf-security-skill
description: Assess whether state-changing requests can be forged across browser security boundaries.
---

# CSRF security assessment

Assess whether state-changing requests can be forged across browser security boundaries.

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

Use the prompts below to guide a focused **CSRF** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Prompt catalog

### 86. Missing CSRF token check

- **Difficulty:** EASY
- **Slug:** `missing-csrf-token-check`
- **Source prompt:** Identify every state-changing endpoint. Replay each without CSRF token / with an empty token / with another user's token. Report endpoints that still succeed.

### 87. SameSite cookie audit

- **Difficulty:** EASY
- **Slug:** `samesite-cookie-audit`
- **Source prompt:** Check every session cookie's `SameSite` attribute. Report `None` without `Secure`, or `Lax`/missing where it should be `Strict` for sensitive actions.

### 88. CSRF via JSON content-type

- **Difficulty:** MED
- **Slug:** `csrf-via-json-content-type`
- **Source prompt:** If endpoint requires `Content-Type: application/json`, test if it accepts `text/plain` (which allows simple-request CSRF without preflight).

### 89. CSRF via method override

- **Difficulty:** MED
- **Slug:** `csrf-via-method-override`
- **Source prompt:** Try `X-HTTP-Method-Override: POST` on GET endpoints, or `_method=DELETE` in form bodies.

### 90. CSRF token not bound to user

- **Difficulty:** MED
- **Slug:** `csrf-token-not-bound-to-user`
- **Source prompt:** Capture user A's CSRF token, replay with user B's session cookie. Report if the token is generic.

### 91. Login CSRF

- **Difficulty:** MED
- **Slug:** `login-csrf`
- **Source prompt:** Test if an attacker can force-login a victim into the attacker's account (used to harvest later actions).

### 92. CSRF via clickjacking

- **Difficulty:** EASY
- **Slug:** `csrf-via-clickjacking`
- **Source prompt:** Check `X-Frame-Options` / CSP `frame-ancestors` on every sensitive page. Build a clickjacking PoC for missing ones.

### 93. CSRF via flash/SWF

- **Difficulty:** HARD
- **Slug:** `csrf-via-flash-swf`
- **Source prompt:** Legacy: check for crossdomain.xml allowing `*`, enabling SWF-based CSRF.

### 94. Double-submit cookie weakness

- **Difficulty:** HARD
- **Slug:** `double-submit-cookie-weakness`
- **Source prompt:** If app uses double-submit cookies, check if attacker can set the cookie via subdomain to bypass.

### 95. Referer/Origin check bypass

- **Difficulty:** MED
- **Slug:** `referer-origin-check-bypass`
- **Source prompt:** If app validates Referer, test missing Referer, null Referer (via `<meta name=referrer content=no-referrer>`), and subdomain Referer.

## Source attribution

- Source: [https://hackwithclaude.com/prompts](https://hackwithclaude.com/prompts)
- Retrieved: 2026-08-28
- Included prompts: 10
