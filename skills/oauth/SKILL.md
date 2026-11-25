---
name: claude-oauth-security-skill
description: Assess OAuth and OpenID Connect flows for redirect, state, token, and client-validation weaknesses.
---

# OAUTH security assessment

Assess OAuth and OpenID Connect flows for redirect, state, token, and client-validation weaknesses.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **OAUTH** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** A token, code, or redirect is accepted outside its intended audience, scope, or redirect_uri allowlist, letting credentials obtained for one party be used by another.
- **False positive when:** The provider or client correctly rejects a mismatched token or state after an initially ambiguous response, or the flow needs a precondition outside the OAuth trust model (e.g., an already-compromised client secret).

## Prompt catalog

### 224. OAuth `redirect_uri` open redirect

- **Difficulty:** HARD
- **Slug:** `oauth-redirect-uri-open-redirect`
- **Source prompt:** Test `redirect_uri` for path traversal, subdomain wildcards, fragment overrides.

### 225. OAuth state missing / weak

- **Difficulty:** MED
- **Slug:** `oauth-state-missing-weak`
- **Source prompt:** Confirm `state` is sent, validated, and bound to session. CSRF the callback if not.
- **Steps:**
  1. Confirm `state` is sent, validated, and bound to session.
  2. CSRF the callback if not.

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
