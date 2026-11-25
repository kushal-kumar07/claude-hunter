---
name: claude-csrf-security-skill
description: Assess whether state-changing requests can be forged across browser security boundaries.
---

# CSRF security assessment

Assess whether state-changing requests can be forged across browser security boundaries.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **CSRF** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** A state-changing request succeeds cross-origin using only the victim's ambient session (no validated anti-CSRF token, no effective same-site cookie policy), reproduced in an isolated browser session.
- **False positive when:** A valid anti-CSRF token or same-site cookie policy actually blocks the cross-origin request, or the targeted action has no real-world state effect.

## Prompt catalog

### 86. Missing CSRF token check

- **Difficulty:** EASY
- **Slug:** `missing-csrf-token-check`
- **Source prompt:** Identify every state-changing endpoint. Replay each without CSRF token / with an empty token / with another user's token. Report endpoints that still succeed.
- **Steps:**
  1. Identify every state-changing endpoint.
  2. Replay each without CSRF token / with an empty token / with another user's token.
  3. Report endpoints that still succeed.

### 87. SameSite cookie audit

- **Difficulty:** EASY
- **Slug:** `samesite-cookie-audit`
- **Source prompt:** Check every session cookie's `SameSite` attribute. Report `None` without `Secure`, or `Lax`/missing where it should be `Strict` for sensitive actions.
- **Steps:**
  1. Check every session cookie's `SameSite` attribute.
  2. Report `None` without `Secure`, or `Lax`/missing where it should be `Strict` for sensitive actions.

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
- **Steps:**
  1. Capture user A's CSRF token, replay with user B's session cookie.
  2. Report if the token is generic.

### 91. Login CSRF

- **Difficulty:** MED
- **Slug:** `login-csrf`
- **Source prompt:** Test if an attacker can force-login a victim into the attacker's account (used to harvest later actions).

### 92. CSRF via clickjacking

- **Difficulty:** EASY
- **Slug:** `csrf-via-clickjacking`
- **Source prompt:** Check `X-Frame-Options` / CSP `frame-ancestors` on every sensitive page. Build a clickjacking PoC for missing ones.
- **Steps:**
  1. Check `X-Frame-Options` / CSP `frame-ancestors` on every sensitive page.
  2. Build a clickjacking PoC for missing ones.

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
