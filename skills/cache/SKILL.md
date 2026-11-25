---
name: claude-cache-security-skill
description: Assess cache keying, poisoning, deception, and sensitive-response storage behavior.
---

# CACHE security assessment

Assess cache keying, poisoning, deception, and sensitive-response storage behavior.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **CACHE** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** A cache stores one user's private response and serves it to a different, unauthorized user, reproduced with two distinct sessions.
- **False positive when:** The cache key correctly includes the differentiating input, or the "poisoned" response is only ever served back to the same attacker session.

## Prompt catalog

### 238. Web cache deception

- **Difficulty:** HARD
- **Slug:** `web-cache-deception`
- **Source prompt:** Append `/style.css`, `/x.js` to authenticated URLs (`/account/x.css`). If CDN caches the response, sensitive data leaks.
- **Steps:**
  1. Append `/style.css`, `/x.js` to authenticated URLs (`/account/x.css`).
  2. If CDN caches the response, sensitive data leaks.

### 239. Cache poisoning via header

- **Difficulty:** HARD
- **Slug:** `cache-poisoning-via-header`
- **Source prompt:** Send unkeyed headers (`X-Forwarded-Host`, `X-Original-URL`) that reflect into responses. Poison cache for next visitor.
- **Steps:**
  1. Send unkeyed headers (`X-Forwarded-Host`, `X-Original-URL`) that reflect into responses.
  2. Poison cache for next visitor.

### 240. Cache poisoning via param cloaking

- **Difficulty:** HARD
- **Slug:** `cache-poisoning-via-param-cloaking`
- **Source prompt:** Test parameter cloaking: `?utm=1&utm=2`, fat GET keys.

### 241. Private data cached by CDN

- **Difficulty:** EASY
- **Slug:** `private-data-cached-by-cdn`
- **Source prompt:** Check `Cache-Control` on `/me`, `/profile`. Should be `private, no-store`.
- **Steps:**
  1. Check `Cache-Control` on `/me`, `/profile`.
  2. Should be `private, no-store`.

### 242. Vary header mistakes

- **Difficulty:** MED
- **Slug:** `vary-header-mistakes`
- **Source prompt:** If response varies by cookie but `Vary` doesn't include `Cookie`, cross-user cache hits occur.

### 243. Request smuggling chain

- **Difficulty:** HARD
- **Slug:** `request-smuggling-chain`
- **Source prompt:** Test HTTP/2 → HTTP/1.1 downgrade smuggling, CL.TE, TE.CL with the front-end / back-end pair.
