---
name: claude-supply-security-skill
description: Assess software supply-chain, dependency, build, action, and package integrity risks.
---

# SUPPLY security assessment

Assess software supply-chain, dependency, build, action, and package integrity risks.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **SUPPLY** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** A dependency, build step, or CI configuration is shown to execute tester-controlled code inside the target's trusted build or runtime, demonstrated with no further unauthorized action.
- **False positive when:** The dependency is pinned and verified against substitution, or the finding is theoretical with no demonstrated crossing of a trust boundary.

## Prompt catalog

### 287. Dependency confusion

- **Difficulty:** HARD
- **Slug:** `dependency-confusion`
- **Source prompt:** Compare `package.json` internal deps to public npm. Publish stubs for unclaimed internal names.
- **Steps:**
  1. Compare `package.json` internal deps to public npm.
  2. Publish stubs for unclaimed internal names.

### 288. Typosquatting check

- **Difficulty:** MED
- **Slug:** `typosquatting-check`
- **Source prompt:** Enumerate the org's dependencies. Search for typosquats (`reqests`, `loadash`).
- **Steps:**
  1. Enumerate the org's dependencies.
  2. Search for typosquats (`reqests`, `loadash`).

### 289. Build-time SSRF / RCE

- **Difficulty:** HARD
- **Slug:** `build-time-ssrf-rce`
- **Source prompt:** Audit `postinstall` scripts in deps for outbound requests, file writes. Report risky packages.
- **Steps:**
  1. Audit `postinstall` scripts in deps for outbound requests, file writes.
  2. Report risky packages.

### 290. GitHub Action takeover

- **Difficulty:** MED
- **Slug:** `github-action-takeover`
- **Source prompt:** Audit `uses:` references — pinned to commit? Or floating tag/branch (`@main`)? Document risk.
