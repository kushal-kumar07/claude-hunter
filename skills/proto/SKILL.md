---
name: claude-proto-security-skill
description: Assess prototype pollution and unsafe object-property merging across application boundaries.
---

# PROTO security assessment

Assess prototype pollution and unsafe object-property merging across application boundaries.

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

Use the prompts below to guide a focused **PROTO** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Prompt catalog

### 248. Client-side proto pollution probe

- **Difficulty:** MED
- **Slug:** `client-side-proto-pollution-probe`
- **Source prompt:** Visit pages with `?__proto__[test]=1`, then `console.log({}.test)` in DevTools. If `1`, pollution exists.

### 249. Server-side proto pollution via JSON

- **Difficulty:** HARD
- **Slug:** `server-side-proto-pollution-via-json`
- **Source prompt:** POST `{"__proto__":{"isAdmin":true}}` to JSON endpoints. Then trigger logic that checks `obj.isAdmin`.

### 250. Proto pollution → XSS gadget

- **Difficulty:** HARD
- **Slug:** `proto-pollution-xss-gadget`
- **Source prompt:** After polluting `Object.prototype`, look for libraries (jQuery, AngularJS) that use the polluted property as a sink.

### 251. Proto pollution → RCE in Node

- **Difficulty:** HARD
- **Slug:** `proto-pollution-rce-in-node`
- **Source prompt:** Pollute `__proto__.shell` and similar to control `child_process.spawn` options.

## Source attribution

- Source: [https://hackwithclaude.com/prompts](https://hackwithclaude.com/prompts)
- Retrieved: 2026-08-28
- Included prompts: 4
