---
name: claude-cache-security-skill
description: Assess cache keying, poisoning, deception, and sensitive-response storage behavior.
---

# CACHE security assessment

Assess cache keying, poisoning, deception, and sensitive-response storage behavior.

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

Use the prompts below to guide a focused **CACHE** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Prompt catalog

### 238. Web cache deception

- **Difficulty:** HARD
- **Slug:** `web-cache-deception`
- **Source prompt:** Append `/style.css`, `/x.js` to authenticated URLs (`/account/x.css`). If CDN caches the response, sensitive data leaks.

### 239. Cache poisoning via header

- **Difficulty:** HARD
- **Slug:** `cache-poisoning-via-header`
- **Source prompt:** Send unkeyed headers (`X-Forwarded-Host`, `X-Original-URL`) that reflect into responses. Poison cache for next visitor.

### 240. Cache poisoning via param cloaking

- **Difficulty:** HARD
- **Slug:** `cache-poisoning-via-param-cloaking`
- **Source prompt:** Test parameter cloaking: `?utm=1&utm=2`, fat GET keys.

### 241. Private data cached by CDN

- **Difficulty:** EASY
- **Slug:** `private-data-cached-by-cdn`
- **Source prompt:** Check `Cache-Control` on `/me`, `/profile`. Should be `private, no-store`.

### 242. Vary header mistakes

- **Difficulty:** MED
- **Slug:** `vary-header-mistakes`
- **Source prompt:** If response varies by cookie but `Vary` doesn't include `Cookie`, cross-user cache hits occur.

### 243. Request smuggling chain

- **Difficulty:** HARD
- **Slug:** `request-smuggling-chain`
- **Source prompt:** Test HTTP/2 → HTTP/1.1 downgrade smuggling, CL.TE, TE.CL with the front-end / back-end pair.

## Source attribution

- Source: [https://hackwithclaude.com/prompts](https://hackwithclaude.com/prompts)
- Retrieved: 2026-08-28
- Included prompts: 6
