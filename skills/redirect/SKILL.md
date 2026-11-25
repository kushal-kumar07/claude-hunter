---
name: claude-redirect-security-skill
description: Assess redirect and navigation parameters for unsafe destinations and scriptable URL schemes.
---

# REDIRECT security assessment

Assess redirect and navigation parameters for unsafe destinations and scriptable URL schemes.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **REDIRECT** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** The application redirects to, or displays, a URL/host the tester fully controls, reached without an interstitial warning and resembling a trusted destination.
- **False positive when:** The destination is allowlist-validated, or an interstitial page clearly warns the user before leaving the trusted application.

## Prompt catalog

### 132. Basic open redirect probe

- **Difficulty:** EASY
- **Slug:** `basic-open-redirect-probe`
- **Source prompt:** Find every `?next=`, `?redirect=`, `?url=`, `?return_to=`. Submit `https://evil.com` and check Location header.
- **Steps:**
  1. Find every `?next=`, `?redirect=`, `?url=`, `?return_to=`.
  2. Submit `https://evil.com` and check Location header.

### 133. Open redirect via @ trick

- **Difficulty:** MED
- **Slug:** `open-redirect-via-trick`
- **Source prompt:** Test `https://target.com@evil.com/`, `//evil.com`, `/\evil.com`, `/.evil.com`.

### 134. Open redirect via CRLF injection

- **Difficulty:** HARD
- **Slug:** `open-redirect-via-crlf-injection`
- **Source prompt:** Inject `%0D%0ALocation: https://evil.com` into headers that reflect into responses.

### 135. Open redirect in OAuth `redirect_uri`

- **Difficulty:** HARD
- **Slug:** `open-redirect-in-oauth-redirect-uri`
- **Source prompt:** Even if `redirect_uri` is allowlisted, test `https://allowed.com.evil.com`, `https://allowed.com@evil.com`, path traversal.

### 136. Open redirect in logout

- **Difficulty:** EASY
- **Slug:** `open-redirect-in-logout`
- **Source prompt:** Test `/logout?next=evil.com`. Often missed by validators.
- **Steps:**
  1. Test `/logout?next=evil.com`.
  2. Often missed by validators.

### 137. Redirect → XSS chain

- **Difficulty:** MED
- **Slug:** `redirect-xss-chain`
- **Source prompt:** If `javascript:` is allowed in redirect param, escalate to XSS.

## Additional coverage

- OAuth authorization redirects and header-derived destinations.
- JavaScript/data schemes, double encoding, backslashes, parser differentials, and userinfo forms.
- Confirm navigation in a controlled browser with an owned destination; do not redirect victims.
