---
name: claude-race-security-skill
description: Assess concurrent request handling for time-of-check/time-of-use and duplicate-action flaws.
---

# RACE security assessment

Assess concurrent request handling for time-of-check/time-of-use and duplicate-action flaws.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **RACE** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** Concurrent requests produce a result the sequential, single-request flow prevents (double redemption, balance drift, duplicate resource), reproduced across repeated timing attempts.
- **False positive when:** A one-off result explainable by normal retry or idempotency handling, or the anomaly doesn't recur across repeated trials.

## Prompt catalog

### 138. Discount code multi-redeem

- **Difficulty:** MED
- **Slug:** `discount-code-multi-redeem`
- **Source prompt:** Apply a single-use discount code 20 times in parallel via Burp Turbo Intruder. Report if more than one succeeds.
- **Steps:**
  1. Apply a single-use discount code 20 times in parallel via Burp Turbo Intruder.
  2. Report if more than one succeeds.

### 139. Wallet double-spend

- **Difficulty:** HARD
- **Slug:** `wallet-double-spend`
- **Source prompt:** Withdraw entire balance in N concurrent requests. Report if total withdrawn exceeds balance.
- **Steps:**
  1. Withdraw entire balance in N concurrent requests.
  2. Report if total withdrawn exceeds balance.

### 140. Email verification race

- **Difficulty:** HARD
- **Slug:** `email-verification-race`
- **Source prompt:** Request email change to victim@target, then quickly request to attacker@evil — race the verification.

### 141. Signup race for unique handle

- **Difficulty:** MED
- **Slug:** `signup-race-for-unique-handle`
- **Source prompt:** Submit the same username 50 times concurrently. Check for duplicates.
- **Steps:**
  1. Submit the same username 50 times concurrently.
  2. Check for duplicates.

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
