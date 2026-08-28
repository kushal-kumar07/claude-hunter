---
name: claude-race-security-skill
description: Assess concurrent request handling for time-of-check/time-of-use and duplicate-action flaws.
---

# RACE security assessment

Assess concurrent request handling for time-of-check/time-of-use and duplicate-action flaws.

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

Use the prompts below to guide a focused **RACE** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Prompt catalog

### 138. Discount code multi-redeem

- **Difficulty:** MED
- **Slug:** `discount-code-multi-redeem`
- **Source prompt:** Apply a single-use discount code 20 times in parallel via Burp Turbo Intruder. Report if more than one succeeds.

### 139. Wallet double-spend

- **Difficulty:** HARD
- **Slug:** `wallet-double-spend`
- **Source prompt:** Withdraw entire balance in N concurrent requests. Report if total withdrawn exceeds balance.

### 140. Email verification race

- **Difficulty:** HARD
- **Slug:** `email-verification-race`
- **Source prompt:** Request email change to victim@target, then quickly request to attacker@evil — race the verification.

### 141. Signup race for unique handle

- **Difficulty:** MED
- **Slug:** `signup-race-for-unique-handle`
- **Source prompt:** Submit the same username 50 times concurrently. Check for duplicates.

### 142. Like/vote race past cap

- **Difficulty:** EASY
- **Slug:** `like-vote-race-past-cap`
- **Source prompt:** If a poll/like is capped at 1 per user, send 100 in parallel.

### 143. TOCTOU on file ops

- **Difficulty:** HARD
- **Slug:** `toctou-on-file-ops`
- **Source prompt:** Race the gap between file validation and use (e.g., MIME check then move).

### 144. Race on password reset

- **Difficulty:** MED
- **Slug:** `race-on-password-reset`
- **Source prompt:** Trigger many resets concurrently — check if old tokens remain valid alongside new.

### 145. Race on 2FA enrollment

- **Difficulty:** HARD
- **Slug:** `race-on-2fa-enrollment`
- **Source prompt:** Race enrolling 2FA while disabling it.

## Source attribution

- Source: [https://hackwithclaude.com/prompts](https://hackwithclaude.com/prompts)
- Retrieved: 2026-08-28
- Included prompts: 8
