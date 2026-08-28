---
name: claude-idor-security-skill
description: Verify object-level authorization across identifiers, resources, and tenant boundaries.
---

# IDOR security assessment

Verify object-level authorization across identifiers, resources, and tenant boundaries.

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

Use the prompts below to guide a focused **IDOR** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Prompt catalog

### 56. Sequential ID enumeration

- **Difficulty:** EASY
- **Slug:** `sequential-id-enumeration`
- **Source prompt:** Identify every endpoint with numeric IDs (`/users/123`, `/orders/456`). Authenticate as user A, then access user B's IDs (±1, ±10, ±100). Report any 200 responses.

### 57. UUID guessing via leaked endpoints

- **Difficulty:** MED
- **Slug:** `uuid-guessing-via-leaked-endpoints`
- **Source prompt:** Search for endpoints that leak UUIDs of other users (search, public listings, exports). Use leaked UUIDs to access private resources.

### 58. Method-based authz bypass

- **Difficulty:** EASY
- **Slug:** `method-based-authz-bypass`
- **Source prompt:** If `GET /resource/1` is forbidden, try `POST`, `PUT`, `DELETE`, `PATCH`, `OPTIONS`. Also try `HEAD` for info disclosure.

### 59. Mass assignment

- **Difficulty:** MED
- **Slug:** `mass-assignment`
- **Source prompt:** On profile/order update endpoints, add fields like `role:"admin"`, `isVerified:true`, `balance:99999`, `userId:<other>`. Report fields silently accepted.

### 60. IDOR via PATCH with foreign keys

- **Difficulty:** HARD
- **Slug:** `idor-via-patch-with-foreign-keys`
- **Source prompt:** On PATCH endpoints, change `owner_id`, `team_id`, `org_id` to another tenant's ID. Confirm cross-tenant write.

### 61. Force-browsing admin routes

- **Difficulty:** EASY
- **Slug:** `force-browsing-admin-routes`
- **Source prompt:** Brute force common admin paths (`/admin`, `/internal`, `/dashboard`, `/api/admin/*`) as a low-priv user. Diff with anonymous responses.

### 62. Role downgrade via JSON

- **Difficulty:** MED
- **Slug:** `role-downgrade-via-json`
- **Source prompt:** On role assignment endpoints, try assigning `superadmin`, `owner`, `god`. Test casing and locale (`ADMIN`, `Admin `).

### 63. Tenant header confusion

- **Difficulty:** MED
- **Slug:** `tenant-header-confusion`
- **Source prompt:** Try `X-Tenant-Id`, `X-Org-Id`, `X-Account-Id` headers. Swap to another tenant's ID with your auth token.

### 64. GraphQL node global ID guess

- **Difficulty:** MED
- **Slug:** `graphql-node-global-id-guess`
- **Source prompt:** Decode base64 GraphQL IDs (`User:1`), increment, re-encode, refetch.

### 65. IDOR in file storage URLs

- **Difficulty:** MED
- **Slug:** `idor-in-file-storage-urls`
- **Source prompt:** Direct S3/GCS/Azure URLs often have predictable paths. Enumerate `/uploads/{userId}/...`.

### 66. Indirect IDOR via slugs

- **Difficulty:** MED
- **Slug:** `indirect-idor-via-slugs`
- **Source prompt:** If slugs are derived from titles, enumerate likely slugs of private docs (`/docs/q4-financials`).

### 67. IDOR in invitation tokens

- **Difficulty:** MED
- **Slug:** `idor-in-invitation-tokens`
- **Source prompt:** Test if invite tokens are predictable (short, sequential, time-based). Reuse expired tokens.

### 68. Privilege check skipped on bulk endpoint

- **Difficulty:** HARD
- **Slug:** `privilege-check-skipped-on-bulk-endpoint`
- **Source prompt:** Bulk endpoints (`/batch`, `/bulk`) often skip per-item authz. Include a victim's ID in a batch update.

### 69. GET-to-POST authz drift

- **Difficulty:** MED
- **Slug:** `get-to-post-authz-drift`
- **Source prompt:** If GET enforces authz but POST/PUT does not (or vice versa), find the inconsistent verb.

### 70. IDOR via export / download

- **Difficulty:** MED
- **Slug:** `idor-via-export-download`
- **Source prompt:** Export endpoints (`/export?ids=1,2,3`) sometimes accept other users' IDs. Verify per-ID checks.

## Source attribution

- Source: [https://hackwithclaude.com/prompts](https://hackwithclaude.com/prompts)
- Retrieved: 2026-08-28
- Included prompts: 15

## Additional coverage

- Blind, nested-object, bulk/export/download, GraphQL, WebSocket, and cross-tenant IDOR.
- Compare ownership and authorization at every nested resource boundary, not only the root object.
- Prove with two owned principals and the minimum synthetic record; do not enumerate identifiers.

### Source attribution

- Adapted from `SnailSploit/Claude-Red` `Skills/web/offensive-idor/SKILL.md`.
- Source repository: https://github.com/SnailSploit/Claude-Red
