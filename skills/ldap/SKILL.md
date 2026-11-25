---
name: claude-ldap-security-skill
description: Assess LDAP filter and distinguished-name construction for injection and directory boundary failures.
---

# LDAP security assessment

Assess LDAP filter and distinguished-name construction for injection and directory boundary failures.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **LDAP** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** Injected filter operators change which directory entries match, bypassing an intended filter or authentication check.
- **False positive when:** The LDAP library escapes special characters, so the injected syntax is treated as literal text with no effect.

## Prompt catalog

### 255. LDAP injection in login

- **Difficulty:** MED
- **Slug:** `ldap-injection-in-login`
- **Source prompt:** Send `*)(uid=*))(|(uid=*` and `admin)(&)` in username fields against LDAP-backed auth.

### 256. Blind LDAP via boolean

- **Difficulty:** HARD
- **Slug:** `blind-ldap-via-boolean`
- **Source prompt:** Use `*)(cn=a*` to enumerate values; observe true/false response diffs.

### 257. LDAP search filter injection

- **Difficulty:** HARD
- **Slug:** `ldap-search-filter-injection`
- **Source prompt:** On search endpoints backed by LDAP, inject filter operators to bypass constraints.
