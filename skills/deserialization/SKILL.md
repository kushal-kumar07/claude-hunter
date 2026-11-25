---
name: claude-deserialization-security-skill
description: Assess unsafe deserialization boundaries and gadget-capable formats without causing harm.
---

# DESERIALIZATION security assessment

Assess unsafe deserialization boundaries and gadget-capable formats without causing harm.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **DESERIALIZATION** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** A crafted serialized object triggers unintended code execution or object state outside what application logic permits, proven via a safe out-of-band signal.
- **False positive when:** The parser rejects the crafted object outright, or the sink only ever deserializes into a safe, non-executable type.

## Prompt catalog

### 188. Java deserialization

- **Difficulty:** HARD
- **Slug:** `java-deserialization`
- **Source prompt:** Find endpoints accepting `application/x-java-serialized-object` or base64 `rO0AB...`. Replay with ysoserial gadgets.
- **Steps:**
  1. Find endpoints accepting `application/x-java-serialized-object` or base64 `rO0AB...`.
  2. Replay with ysoserial gadgets.

### 189. PHP `unserialize` abuse

- **Difficulty:** HARD
- **Slug:** `php-unserialize-abuse`
- **Source prompt:** Identify PHP cookies/params containing `O:N:`. Replace with PHPGGC payloads.
- **Steps:**
  1. Identify PHP cookies/params containing `O:N:`.
  2. Replace with PHPGGC payloads.

### 190. Python `pickle` exec

- **Difficulty:** HARD
- **Slug:** `python-pickle-exec`
- **Source prompt:** Any endpoint that loads pickled data → RCE via `__reduce__`.

### 191. .NET ViewState

- **Difficulty:** HARD
- **Slug:** `net-viewstate`
- **Source prompt:** If app uses WebForms, test ViewState with known machine key disclosure → ysoserial.net gadgets.

### 192. Node.js `node-serialize` IIFE

- **Difficulty:** HARD
- **Slug:** `node-js-node-serialize-iife`
- **Source prompt:** If app uses `node-serialize`, payload `{"rce":"_$$ND_FUNC$$_function(){...}()"}`.
