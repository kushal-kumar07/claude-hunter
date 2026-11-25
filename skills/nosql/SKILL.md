---
name: claude-nosql-security-skill
description: Assess NoSQL query construction and operator handling for injection and authorization bypass.
---

# NOSQL security assessment

Assess NoSQL query construction and operator handling for injection and authorization bypass.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **NOSQL** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** Injecting operators or objects into a NoSQL query changes its logical result (bypasses an auth check or returns out-of-scope documents).
- **False positive when:** The driver or schema strictly types the input so operator injection has no effect, or the result difference has a normal, non-security explanation.

## Prompt catalog

### 252. NoSQL operator injection

- **Difficulty:** MED
- **Slug:** `nosql-operator-injection`
- **Source prompt:** Replace string params with `{"$ne":null}`, `{"$gt":""}`, `{"$regex":".*"}` in JSON bodies.

### 253. NoSQL $where JS execution

- **Difficulty:** HARD
- **Slug:** `nosql-where-js-execution`
- **Source prompt:** If app uses `$where`, inject `function(){return true}` or `sleep(5000)`.

### 254. NoSQL blind via regex timing

- **Difficulty:** HARD
- **Slug:** `nosql-blind-via-regex-timing`
- **Source prompt:** Use `^a.*`, `^b.*` regexes and time responses to enumerate values char by char.
