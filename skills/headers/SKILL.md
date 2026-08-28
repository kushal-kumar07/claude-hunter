---
name: claude-headers-security-skill
description: Assess HTTP security headers, proxy trust, host handling, and header-driven security controls.
---

# HEADERS security assessment

Assess HTTP security headers, proxy trust, host handling, and header-driven security controls.

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

Use the prompts below to guide a focused **HEADERS** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Prompt catalog

### 232. Audit security headers

- **Difficulty:** EASY
- **Slug:** `audit-security-headers`
- **Source prompt:** For every public URL, report presence/values of: CSP, HSTS, X-Frame-Options, X-Content-Type-Options, Referrer-Policy, Permissions-Policy, COOP, COEP, CORP.

### 233. Missing HSTS

- **Difficulty:** EASY
- **Slug:** `missing-hsts`
- **Source prompt:** Confirm `Strict-Transport-Security: max-age>=31536000; includeSubDomains; preload`. Test stripping over HTTP.

### 234. Clickjacking via missing XFO/CSP

- **Difficulty:** EASY
- **Slug:** `clickjacking-via-missing-xfo-csp`
- **Source prompt:** Build framing PoC for any sensitive page (transfer, settings, OAuth confirm) lacking `frame-ancestors`.

### 235. Missing X-Content-Type-Options

- **Difficulty:** MED
- **Slug:** `missing-x-content-type-options`
- **Source prompt:** Without `nosniff`, browsers MIME-sniff — uploaded JS may execute. PoC.

### 236. Permissive Referrer-Policy

- **Difficulty:** MED
- **Slug:** `permissive-referrer-policy`
- **Source prompt:** If `Referrer-Policy: unsafe-url`, sensitive URLs leak to third parties.

### 237. CSP weakness

- **Difficulty:** MED
- **Slug:** `csp-weakness`
- **Source prompt:** Report `unsafe-inline`, `unsafe-eval`, overbroad `*`, wildcard CDNs, missing `object-src 'none'`, `base-uri 'self'`.

## Source attribution

- Source: [https://hackwithclaude.com/prompts](https://hackwithclaude.com/prompts)
- Retrieved: 2026-08-28
- Included prompts: 6

## Additional web checks: host and forwarding headers

Review `Host`, `X-Forwarded-Host`, `Forwarded`, and related proxy headers in password-reset links,
absolute URLs, redirects, cacheable HTML, OAuth issuer/redirect construction, and routing. Use a
unique owned canary domain and a test inbox; confirm reflection or routing at the intended layer.
Do not claim poisoning from a reflected header without proving cache behavior, and do not probe
cloud metadata or internal services without explicit scope.

Reject untrusted host values with an allowlist, normalize proxy headers at the edge, and ensure
application URL generation uses configured canonical origins.

### Source attribution

- Adapted from `elementalsouls/Claude-BugHunter` `skills/hunt-host-header/SKILL.md`.
- Repository content license: CC BY 4.0.
