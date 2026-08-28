---
name: claude-deserialization-security-skill
description: Assess unsafe deserialization boundaries and gadget-capable formats without causing harm.
---

# DESERIALIZATION security assessment

Assess unsafe deserialization boundaries and gadget-capable formats without causing harm.

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

Use the prompts below to guide a focused **DESERIALIZATION** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Prompt catalog

### 188. Java deserialization

- **Difficulty:** HARD
- **Slug:** `java-deserialization`
- **Source prompt:** Find endpoints accepting `application/x-java-serialized-object` or base64 `rO0AB...`. Replay with ysoserial gadgets.

### 189. PHP `unserialize` abuse

- **Difficulty:** HARD
- **Slug:** `php-unserialize-abuse`
- **Source prompt:** Identify PHP cookies/params containing `O:N:`. Replace with PHPGGC payloads.

### 190. Python `pickle` exec

- **Difficulty:** HARD
- **Slug:** `python-pickle-exec`
- **Source prompt:** Any endpoint that loads pickled data → RCE via `__reduce__`.

### 191. .NET ViewState

- **Difficulty:** HARD
- **Slug:** `net-viewstate`
- **Source prompt:** If app uses WebForms, test ViewState with known machine key disclosure → ysoserial.net gadgets.

### 192. Node.js `node-serialize` IIFE

- **Difficulty:** HARD
- **Slug:** `node-js-node-serialize-iife`
- **Source prompt:** If app uses `node-serialize`, payload `{"rce":"_$$ND_FUNC$$_function(){...}()"}`.

## Source attribution

- Source: [https://hackwithclaude.com/prompts](https://hackwithclaude.com/prompts)
- Retrieved: 2026-08-28
- Included prompts: 5
