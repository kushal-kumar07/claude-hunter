---
name: claude-cors-security-skill
description: Assess cross-origin policy validation and whether sensitive responses are exposed to untrusted origins.
---

# CORS security assessment

Assess cross-origin policy validation and whether sensitive responses are exposed to untrusted origins.

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

Use the prompts below to guide a focused **CORS** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Prompt catalog

### 176. Wildcard with credentials

- **Difficulty:** EASY
- **Slug:** `wildcard-with-credentials`
- **Source prompt:** Set `Origin: https://evil.com`. If response returns `Access-Control-Allow-Origin: *` with `Allow-Credentials: true` or echoes the origin, report.

### 177. Null origin trust

- **Difficulty:** MED
- **Slug:** `null-origin-trust`
- **Source prompt:** Set `Origin: null` (sandboxed iframe). If app trusts null, demonstrate cross-origin read.

### 178. Origin subdomain bypass

- **Difficulty:** MED
- **Slug:** `origin-subdomain-bypass`
- **Source prompt:** Test `Origin: https://target.com.evil.com`, `https://eviltarget.com`, `https://target-com.evil.com`. Misconfigured regex often allows.

### 179. CORS preflight cache poisoning

- **Difficulty:** HARD
- **Slug:** `cors-preflight-cache-poisoning`
- **Source prompt:** Test if a single preflight allows broad subsequent reqs unexpectedly.

### 180. Trust of any HTTPS origin

- **Difficulty:** MED
- **Slug:** `trust-of-any-https-origin`
- **Source prompt:** Try `Origin: https://attacker.com` and `http://target.com`. Report scheme/port mismatches accepted.

### 181. Read sensitive API via CORS

- **Difficulty:** MED
- **Slug:** `read-sensitive-api-via-cors`
- **Source prompt:** Use the misconfig to build a PoC fetching `/me` or billing data from `evil.com`.

## Source attribution

- Source: [https://hackwithclaude.com/prompts](https://hackwithclaude.com/prompts)
- Retrieved: 2026-08-28
- Included prompts: 6
