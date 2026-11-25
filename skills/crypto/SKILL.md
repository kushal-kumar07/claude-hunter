---
name: claude-crypto-security-skill
description: Assess cryptographic primitives, randomness, key handling, modes, and password storage choices.
---

# CRYPTO security assessment

Assess cryptographic primitives, randomness, key handling, modes, and password storage choices.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **CRYPTO** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** A weak or predictable key, nonce reuse, or broken primitive is demonstrated to let the tester forge, decrypt, or predict a value with real security impact.
- **False positive when:** The primitive looks weak in isolation but the value never crosses a trust boundary, or its use is cosmetic rather than security-relevant.

## Prompt catalog

### 218. ECB mode plaintext leak

- **Difficulty:** MED
- **Slug:** `ecb-mode-plaintext-leak`
- **Source prompt:** If app encrypts with ECB, encrypt repeating plaintext and check for block patterns.

### 219. Padding oracle

- **Difficulty:** HARD
- **Slug:** `padding-oracle`
- **Source prompt:** Look for endpoints decrypting attacker-controlled ciphertext (CBC mode). Test with padbuster / hashcat oracles.
- **Steps:**
  1. Look for endpoints decrypting attacker-controlled ciphertext (CBC mode).
  2. Test with padbuster / hashcat oracles.

### 220. IV reuse with CBC

- **Difficulty:** HARD
- **Slug:** `iv-reuse-with-cbc`
- **Source prompt:** Confirm IVs are unique per message — replay with identical IV reveals XOR of plaintexts.

### 221. Weak hashing for passwords

- **Difficulty:** EASY
- **Slug:** `weak-hashing-for-passwords`
- **Source prompt:** Inspect stored password hashes. Report MD5, SHA1, unsalted, low bcrypt cost.
- **Steps:**
  1. Inspect stored password hashes.
  2. Report MD5, SHA1, unsalted, low bcrypt cost.

### 222. Predictable randomness

- **Difficulty:** MED
- **Slug:** `predictable-randomness`
- **Source prompt:** Tokens generated via `Math.random()`, `time()`, or PHP `mt_rand()` are predictable. Test entropy.
- **Steps:**
  1. Tokens generated via `Math.random()`, `time()`, or PHP `mt_rand()` are predictable.
  2. Test entropy.

### 223. Custom crypto roll-your-own

- **Difficulty:** HARD
- **Slug:** `custom-crypto-roll-your-own`
- **Source prompt:** Flag any function named `encrypt`, `obfuscate`, `scramble`. Reverse and demonstrate weakness.
- **Steps:**
  1. Flag any function named `encrypt`, `obfuscate`, `scramble`.
  2. Reverse and demonstrate weakness.

