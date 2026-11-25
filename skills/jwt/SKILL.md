---
name: claude-jwt-security-skill
description: Assess JSON Web Token validation, key handling, claims enforcement, and token lifecycle controls.
---

# JWT security assessment

Assess JSON Web Token validation, key handling, claims enforcement, and token lifecycle controls.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **JWT** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** A modified or forged token (algorithm, claim, or signature) is accepted by the server with elevated or cross-tenant privileges.
- **False positive when:** The modified token is rejected (401/403) even though a prior inspection of the server's behavior looked permissive.

## Prompt catalog

### 168. JWT `alg: none`

- **Difficulty:** EASY
- **Slug:** `jwt-alg-none`
- **Source prompt:** Capture a JWT, set `alg: none`, drop the signature. Replay.
- **Steps:**
  1. Capture a JWT, set `alg: none`, drop the signature.
  2. Replay.

### 169. JWT HS256 with public key

- **Difficulty:** HARD
- **Slug:** `jwt-hs256-with-public-key`
- **Source prompt:** If the server expects RS256, forge an HS256 token using the public key as the HMAC secret.

### 170. JWT weak secret

- **Difficulty:** MED
- **Slug:** `jwt-weak-secret`
- **Source prompt:** Run `hashcat -m 16500` against the JWT with rockyou.txt. Report cracked secrets.
- **Steps:**
  1. Run `hashcat -m 16500` against the JWT with rockyou.txt.
  2. Report cracked secrets.

### 171. JWT `kid` injection

- **Difficulty:** HARD
- **Slug:** `jwt-kid-injection`
- **Source prompt:** Inject `kid: "../../dev/null"`, `kid: "/etc/passwd"`, or SQLi into `kid` claim.

### 172. JWT `jku` / `jwk` header abuse

- **Difficulty:** HARD
- **Slug:** `jwt-jku-jwk-header-abuse`
- **Source prompt:** Set `jku` to attacker-controlled URL hosting a JWKS — sign with matching key.

### 173. JWT claim tampering (no sig check)

- **Difficulty:** EASY
- **Slug:** `jwt-claim-tampering-no-sig-check`
- **Source prompt:** Modify `role`, `sub`, `aud` and replay. Some apps decode without verifying.
- **Steps:**
  1. Modify `role`, `sub`, `aud` and replay.
  2. Some apps decode without verifying.

### 174. JWT expired/replay

- **Difficulty:** MED
- **Slug:** `jwt-expired-replay`
- **Source prompt:** Test if expired JWTs are still accepted. Replay revoked tokens after logout.
- **Steps:**
  1. Test if expired JWTs are still accepted.
  2. Replay revoked tokens after logout.

### 175. JWT confused deputy (cross-tenant)

- **Difficulty:** HARD
- **Slug:** `jwt-confused-deputy-cross-tenant`
- **Source prompt:** Use a JWT from one tenant on another tenant's API.
