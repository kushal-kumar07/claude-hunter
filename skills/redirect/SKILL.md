---
name: claude-redirect-security-skill
description: Assess redirect and navigation parameters for unsafe destinations and scriptable URL schemes.
---

# REDIRECT security assessment

Assess redirect and navigation parameters for unsafe destinations and scriptable URL schemes.

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

Use the prompts below to guide a focused **REDIRECT** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Prompt catalog

### 132. Basic open redirect probe

- **Difficulty:** EASY
- **Slug:** `basic-open-redirect-probe`
- **Source prompt:** Find every `?next=`, `?redirect=`, `?url=`, `?return_to=`. Submit `https://evil.com` and check Location header.

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

### 137. Redirect → XSS chain

- **Difficulty:** MED
- **Slug:** `redirect-xss-chain`
- **Source prompt:** If `javascript:` is allowed in redirect param, escalate to XSS.

## Source attribution

- Source: [https://hackwithclaude.com/prompts](https://hackwithclaude.com/prompts)
- Retrieved: 2026-08-28
- Included prompts: 6

## Additional coverage

- OAuth authorization redirects and header-derived destinations.
- JavaScript/data schemes, double encoding, backslashes, parser differentials, and userinfo forms.
- Confirm navigation in a controlled browser with an owned destination; do not redirect victims.

### Source attribution

- Adapted from `SnailSploit/Claude-Red` `Skills/web/offensive-open-redirect/SKILL.md`.
- Source repository: https://github.com/SnailSploit/Claude-Red
