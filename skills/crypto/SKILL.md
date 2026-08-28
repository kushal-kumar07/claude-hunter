---
name: claude-crypto-security-skill
description: Assess cryptographic primitives, randomness, key handling, modes, and password storage choices.
---

# CRYPTO security assessment

Assess cryptographic primitives, randomness, key handling, modes, and password storage choices.

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

Use the prompts below to guide a focused **CRYPTO** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Prompt catalog

### 218. ECB mode plaintext leak

- **Difficulty:** MED
- **Slug:** `ecb-mode-plaintext-leak`
- **Source prompt:** If app encrypts with ECB, encrypt repeating plaintext and check for block patterns.

### 219. Padding oracle

- **Difficulty:** HARD
- **Slug:** `padding-oracle`
- **Source prompt:** Look for endpoints decrypting attacker-controlled ciphertext (CBC mode). Test with padbuster / hashcat oracles.

### 220. IV reuse with CBC

- **Difficulty:** HARD
- **Slug:** `iv-reuse-with-cbc`
- **Source prompt:** Confirm IVs are unique per message — replay with identical IV reveals XOR of plaintexts.

### 221. Weak hashing for passwords

- **Difficulty:** EASY
- **Slug:** `weak-hashing-for-passwords`
- **Source prompt:** Inspect stored password hashes. Report MD5, SHA1, unsalted, low bcrypt cost.

### 222. Predictable randomness

- **Difficulty:** MED
- **Slug:** `predictable-randomness`
- **Source prompt:** Tokens generated via `Math.random()`, `time()`, or PHP `mt_rand()` are predictable. Test entropy.

### 223. Custom crypto roll-your-own

- **Difficulty:** HARD
- **Slug:** `custom-crypto-roll-your-own`
- **Source prompt:** Flag any function named `encrypt`, `obfuscate`, `scramble`. Reverse and demonstrate weakness.

## Source attribution

- Source: [https://hackwithclaude.com/prompts](https://hackwithclaude.com/prompts)
- Retrieved: 2026-08-28
- Included prompts: 6
