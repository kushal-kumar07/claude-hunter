---
name: claude-cmdi-security-skill
description: Assess command construction for shell metacharacter injection and unsafe process invocation.
---

# CMDI security assessment

Assess command construction for shell metacharacter injection and unsafe process invocation.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **CMDI** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** Out-of-band proof (a time delay or callback tied to the injected command) shows the server executed an OS command from input, demonstrated with a non-destructive payload.
- **False positive when:** A delay or error also occurs with syntactically invalid, non-executing input, or the input passes through a strict allowlist that never reaches a shell.

## Prompt catalog

### 258. Shell metacharacters in args

- **Difficulty:** MED
- **Slug:** `shell-metacharacters-in-args`
- **Source prompt:** Inject `; id`, `&& id`, `| id`, `` `id` ``, `$(id)`, `%0aid` in fields used in OS commands (DNS lookups, ping, exports).

### 259. Argument injection (no shell)

- **Difficulty:** HARD
- **Slug:** `argument-injection-no-shell`
- **Source prompt:** Even without a shell, `--arg=value` injection in `git`, `curl`, `tar`, `find` can RCE.

### 260. Filename → cmd injection

- **Difficulty:** HARD
- **Slug:** `filename-cmd-injection`
- **Source prompt:** Upload files named `; id;.png`. Test if any conversion/processing pipeline executes the name.
- **Steps:**
  1. Upload files named `; id;.png`.
  2. Test if any conversion/processing pipeline executes the name.

