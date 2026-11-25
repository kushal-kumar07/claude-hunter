---
name: claude-headers-security-skill
description: Assess HTTP security headers, proxy trust, host handling, and header-driven security controls.
---

# HEADERS security assessment

Assess HTTP security headers, proxy trust, host handling, and header-driven security controls.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **HEADERS** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** A missing or misconfigured security header has a demonstrable downstream effect (e.g., no CSP combined with a reachable injection sink).
- **False positive when:** The header is absent but no reachable sink depends on it, or it is set correctly at a layer (CDN/proxy) the direct response just doesn't show.

## Prompt catalog

### 232. Audit security headers

- **Difficulty:** EASY
- **Slug:** `audit-security-headers`
- **Source prompt:** For every public URL, report presence/values of: CSP, HSTS, X-Frame-Options, X-Content-Type-Options, Referrer-Policy, Permissions-Policy, COOP, COEP, CORP.

### 233. Missing HSTS

- **Difficulty:** EASY
- **Slug:** `missing-hsts`
- **Source prompt:** Confirm `Strict-Transport-Security: max-age>=31536000; includeSubDomains; preload`. Test stripping over HTTP.
- **Steps:**
  1. Confirm `Strict-Transport-Security: max-age>=31536000; includeSubDomains; preload`.
  2. Test stripping over HTTP.

### 234. Clickjacking via missing XFO/CSP

- **Difficulty:** EASY
- **Slug:** `clickjacking-via-missing-xfo-csp`
- **Source prompt:** Build framing PoC for any sensitive page (transfer, settings, OAuth confirm) lacking `frame-ancestors`.

### 235. Missing X-Content-Type-Options

- **Difficulty:** MED
- **Slug:** `missing-x-content-type-options`
- **Source prompt:** Without `nosniff`, browsers MIME-sniff — uploaded JS may execute. PoC.
- **Steps:**
  1. Without `nosniff`, browsers MIME-sniff — uploaded JS may execute.
  2. PoC.

### 236. Permissive Referrer-Policy

- **Difficulty:** MED
- **Slug:** `permissive-referrer-policy`
- **Source prompt:** If `Referrer-Policy: unsafe-url`, sensitive URLs leak to third parties.

### 237. CSP weakness

- **Difficulty:** MED
- **Slug:** `csp-weakness`
- **Source prompt:** Report `unsafe-inline`, `unsafe-eval`, overbroad `*`, wildcard CDNs, missing `object-src 'none'`, `base-uri 'self'`.

## Additional web checks: host and forwarding headers

Review `Host`, `X-Forwarded-Host`, `Forwarded`, and related proxy headers in password-reset links,
absolute URLs, redirects, cacheable HTML, OAuth issuer/redirect construction, and routing. Use a
unique owned canary domain and a test inbox; confirm reflection or routing at the intended layer.
Do not claim poisoning from a reflected header without proving cache behavior, and do not probe
cloud metadata or internal services without explicit scope.

Reject untrusted host values with an allowlist, normalize proxy headers at the edge, and ensure
application URL generation uses configured canonical origins.
