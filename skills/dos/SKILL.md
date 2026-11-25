---
name: claude-dos-security-skill
description: Assess resource exhaustion, parser complexity, connection handling, and expensive query behavior safely.
---

# DOS security assessment

Assess resource exhaustion, parser complexity, connection handling, and expensive query behavior safely.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **DOS** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** A single or low-volume request measurably degrades availability or resource usage (CPU, memory, time) disproportionate to normal input, without needing sustained high-volume traffic.
- **False positive when:** Degradation is within normal server variance, or only reproduces via a sustained flood that is out of scope for a single-request hypothesis.

## Prompt catalog

### 291. ReDoS in input validators

- **Difficulty:** MED
- **Slug:** `redos-in-input-validators`
- **Source prompt:** Submit `aaaa...!` (1000 a's) to regex-heavy inputs (email, URL validators). Measure response time.
- **Steps:**
  1. Submit `aaaa...!` (1000 a's) to regex-heavy inputs (email, URL validators).
  2. Measure response time.

### 292. XML / JSON billion laughs

- **Difficulty:** MED
- **Slug:** `xml-json-billion-laughs`
- **Source prompt:** POST nested entities / `[[[...]]]` deeply nested JSON. Report parser blowups.
- **Steps:**
  1. POST nested entities / `[[[...]]]` deeply nested JSON.
  2. Report parser blowups.

### 293. Pagination DoS

- **Difficulty:** EASY
- **Slug:** `pagination-dos`
- **Source prompt:** Set `limit=10000000`. Test query timeouts.
- **Steps:**
  1. Set `limit=10000000`.
  2. Test query timeouts.

### 294. Sort/filter DoS

- **Difficulty:** MED
- **Slug:** `sort-filter-dos`
- **Source prompt:** Sort large tables on unindexed columns. Measure CPU/time.
- **Steps:**
  1. Sort large tables on unindexed columns.
  2. Measure CPU/time.

### 295. Hash collision DoS

- **Difficulty:** HARD
- **Slug:** `hash-collision-dos`
- **Source prompt:** Submit thousands of POST params engineered to collide in the framework's hashmap. Measure CPU spike.
- **Steps:**
  1. Submit thousands of POST params engineered to collide in the framework's hashmap.
  2. Measure CPU spike.

### 296. Slowloris / slow POST

- **Difficulty:** MED
- **Slug:** `slowloris-slow-post`
- **Source prompt:** Hold connections open with partial headers / slow body writes. Test concurrent connection limit.
- **Steps:**
  1. Hold connections open with partial headers / slow body writes.
  2. Test concurrent connection limit.

