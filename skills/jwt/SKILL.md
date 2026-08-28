---
name: claude-jwt-security-skill
description: Assess JSON Web Token validation, key handling, claims enforcement, and token lifecycle controls.
---

# JWT security assessment

Assess JSON Web Token validation, key handling, claims enforcement, and token lifecycle controls.

## Operating rules

- Work only against systems, applications, accounts, and repositories where explicit authorization and a defined test window exist.
- Prefer local fixtures, staging environments, synthetic records, and non-destructive canaries. Do not access, alter, exfiltrate, or persist real user data.
- Establish rate, concurrency, payload-size, and stop limits before testing. Stop immediately if availability, confidentiality, or integrity could be affected.
- Treat a suspected issue as unconfirmed until the request, response, execution/data-flow evidence, affected principal, and security impact are recorded.
- Never use weaponized payloads when a harmless marker or controlled callback can demonstrate the same behavior.
- Redact secrets and personal data in notes. Report remediation guidance and the exact authorization scope alongside findings.

## Assessment workflow

1. Define scope, identities, environment, test limits, and rollback contacts.
2. Inventory relevant endpoints, inputs, parsers, trust boundaries, and user roles.
3. Start with passive inspection and benign markers; compare behavior across roles, methods, encodings, and content types.
4. Use the category prompt catalog below as hypotheses, adapting payloads to safe canaries and the approved environment.
5. Capture reproducible evidence: timestamp, endpoint, method, sanitized request/response, actor, preconditions, observed result, and impact.
6. Validate fixes with regression tests, then document residual risk and monitoring recommendations.

## Finding format

- **Title / severity / confidence**
- **Affected asset and authorization context**
- **Preconditions and reproduction steps**
- **Sanitized evidence and source-to-sink or control-flow path**
- **Security impact and affected users/data**
- **Root cause**
- **Recommended remediation and regression test**

## Category-specific focus

Use the prompts below to guide a focused **JWT** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Prompt catalog

### 168. JWT `alg: none`

- **Difficulty:** EASY
- **Slug:** `jwt-alg-none`
- **Source prompt:** Capture a JWT, set `alg: none`, drop the signature. Replay.

### 169. JWT HS256 with public key

- **Difficulty:** HARD
- **Slug:** `jwt-hs256-with-public-key`
- **Source prompt:** If the server expects RS256, forge an HS256 token using the public key as the HMAC secret.

### 170. JWT weak secret

- **Difficulty:** MED
- **Slug:** `jwt-weak-secret`
- **Source prompt:** Run `hashcat -m 16500` against the JWT with rockyou.txt. Report cracked secrets.

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

### 174. JWT expired/replay

- **Difficulty:** MED
- **Slug:** `jwt-expired-replay`
- **Source prompt:** Test if expired JWTs are still accepted. Replay revoked tokens after logout.

### 175. JWT confused deputy (cross-tenant)

- **Difficulty:** HARD
- **Slug:** `jwt-confused-deputy-cross-tenant`
- **Source prompt:** Use a JWT from one tenant on another tenant's API.

## Source attribution

- Source: [https://hackwithclaude.com/prompts](https://hackwithclaude.com/prompts)
- Retrieved: 2026-08-28
- Included prompts: 8
