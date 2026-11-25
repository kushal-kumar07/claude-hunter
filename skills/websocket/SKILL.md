---
name: claude-websocket-security-skill
description: Assess WebSocket origin, authentication, authorization, and message handling controls.
---

# WEBSOCKET security assessment

Assess WebSocket origin, authentication, authorization, and message handling controls.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **WEBSOCKET** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** A WebSocket endpoint accepts a cross-origin handshake and lets an unauthorized origin exchange authenticated messages.
- **False positive when:** The server validates Origin at handshake and consistently rejects the test origin.

## Prompt catalog

### 244. WebSocket missing origin check

- **Difficulty:** MED
- **Slug:** `websocket-missing-origin-check`
- **Source prompt:** Connect from `evil.com`. If server accepts and sends data, report cross-origin WS hijack.
- **Steps:**
  1. Connect from `evil.com`.
  2. If server accepts and sends data, report cross-origin WS hijack.

### 245. WS auth via cookie only

- **Difficulty:** MED
- **Slug:** `ws-auth-via-cookie-only`
- **Source prompt:** If WS auth relies on cookies (no token), it is CSRF-able from any origin.

### 246. WS message injection

- **Difficulty:** MED
- **Slug:** `ws-message-injection`
- **Source prompt:** Send malformed JSON, oversized messages, binary frames to crash handlers.

### 247. WS authz on subscription topics

- **Difficulty:** MED
- **Slug:** `ws-authz-on-subscription-topics`
- **Source prompt:** Subscribe to other users' topics (`channel:user:{id}`). Test wildcard subs.
- **Steps:**
  1. Subscribe to other users' topics (`channel:user:{id}`).
  2. Test wildcard subs.

