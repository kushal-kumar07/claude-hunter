---
name: claude-proto-security-skill
description: Assess prototype pollution and unsafe object-property merging across application boundaries.
---

# PROTO security assessment

Assess prototype pollution and unsafe object-property merging across application boundaries.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **PROTO** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** Malformed or crafted binary protocol data (e.g., gRPC/Protobuf) is accepted and processed past validation it should fail, with an observable security effect.
- **False positive when:** The server cleanly rejects the malformed message with no effect beyond a normal error response.

## Prompt catalog

### 248. Client-side proto pollution probe

- **Difficulty:** MED
- **Slug:** `client-side-proto-pollution-probe`
- **Source prompt:** Visit pages with `?__proto__[test]=1`, then `console.log({}.test)` in DevTools. If `1`, pollution exists.
- **Steps:**
  1. Visit pages with `?__proto__[test]=1`, then `console.log({}.test)` in DevTools.
  2. If `1`, pollution exists.

### 249. Server-side proto pollution via JSON

- **Difficulty:** HARD
- **Slug:** `server-side-proto-pollution-via-json`
- **Source prompt:** POST `{"__proto__":{"isAdmin":true}}` to JSON endpoints. Then trigger logic that checks `obj.isAdmin`.
- **Steps:**
  1. POST `{"__proto__":{"isAdmin":true}}` to JSON endpoints.
  2. Then trigger logic that checks `obj.isAdmin`.

### 250. Proto pollution → XSS gadget

- **Difficulty:** HARD
- **Slug:** `proto-pollution-xss-gadget`
- **Source prompt:** After polluting `Object.prototype`, look for libraries (jQuery, AngularJS) that use the polluted property as a sink.

### 251. Proto pollution → RCE in Node

- **Difficulty:** HARD
- **Slug:** `proto-pollution-rce-in-node`
- **Source prompt:** Pollute `__proto__.shell` and similar to control `child_process.spawn` options.
