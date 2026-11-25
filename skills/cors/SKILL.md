---
name: claude-cors-security-skill
description: Assess cross-origin policy validation and whether sensitive responses are exposed to untrusted origins.
---

# CORS security assessment

Assess cross-origin policy validation and whether sensitive responses are exposed to untrusted origins.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **CORS** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** The server reflects an arbitrary, untrusted Origin together with Access-Control-Allow-Credentials: true, letting a cross-origin page read authenticated response data.
- **False positive when:** Allow-Credentials is absent, the response carries no sensitive data, or the Origin is checked against a real allowlist.

## Prompt catalog

### 176. Wildcard with credentials

- **Difficulty:** EASY
- **Slug:** `wildcard-with-credentials`
- **Source prompt:** Set `Origin: https://evil.com`. If response returns `Access-Control-Allow-Origin: *` with `Allow-Credentials: true` or echoes the origin, report.
- **Steps:**
  1. Set `Origin: https://evil.com`.
  2. If response returns `Access-Control-Allow-Origin: *` with `Allow-Credentials: true` or echoes the origin, report.

### 177. Null origin trust

- **Difficulty:** MED
- **Slug:** `null-origin-trust`
- **Source prompt:** Set `Origin: null` (sandboxed iframe). If app trusts null, demonstrate cross-origin read.
- **Steps:**
  1. Set `Origin: null` (sandboxed iframe).
  2. If app trusts null, demonstrate cross-origin read.

### 178. Origin subdomain bypass

- **Difficulty:** MED
- **Slug:** `origin-subdomain-bypass`
- **Source prompt:** Test `Origin: https://target.com.evil.com`, `https://eviltarget.com`, `https://target-com.evil.com`. Misconfigured regex often allows.
- **Steps:**
  1. Test `Origin: https://target.com.evil.com`, `https://eviltarget.com`, `https://target-com.evil.com`.
  2. Misconfigured regex often allows.

### 179. CORS preflight cache poisoning

- **Difficulty:** HARD
- **Slug:** `cors-preflight-cache-poisoning`
- **Source prompt:** Test if a single preflight allows broad subsequent reqs unexpectedly.

### 180. Trust of any HTTPS origin

- **Difficulty:** MED
- **Slug:** `trust-of-any-https-origin`
- **Source prompt:** Try `Origin: https://attacker.com` and `http://target.com`. Report scheme/port mismatches accepted.
- **Steps:**
  1. Try `Origin: https://attacker.com` and `http://target.com`.
  2. Report scheme/port mismatches accepted.

### 181. Read sensitive API via CORS

- **Difficulty:** MED
- **Slug:** `read-sensitive-api-via-cors`
- **Source prompt:** Use the misconfig to build a PoC fetching `/me` or billing data from `evil.com`.
