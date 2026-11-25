---
name: claude-idor-security-skill
description: Verify object-level authorization across identifiers, resources, and tenant boundaries.
---

# IDOR security assessment

Verify object-level authorization across identifiers, resources, and tenant boundaries.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **IDOR** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** A request made with one principal's session reads or modifies another principal's resource by changing only an identifier, with no ownership/role check on the server.
- **False positive when:** The identifier is only reachable by brute-forcing an out-of-scope keyspace, or the server returns a generic/empty response rather than another principal's real data.

## Prompt catalog

### 56. Sequential ID enumeration

- **Difficulty:** EASY
- **Slug:** `sequential-id-enumeration`
- **Source prompt:** Identify every endpoint with numeric IDs (`/users/123`, `/orders/456`). Authenticate as user A, then access user B's IDs (±1, ±10, ±100). Report any 200 responses.
- **Steps:**
  1. Identify every endpoint with numeric IDs (`/users/123`, `/orders/456`).
  2. Authenticate as user A, then access user B's IDs (±1, ±10, ±100).
  3. Report any 200 responses.

### 57. UUID guessing via leaked endpoints

- **Difficulty:** MED
- **Slug:** `uuid-guessing-via-leaked-endpoints`
- **Source prompt:** Search for endpoints that leak UUIDs of other users (search, public listings, exports). Use leaked UUIDs to access private resources.
- **Steps:**
  1. Search for endpoints that leak UUIDs of other users (search, public listings, exports).
  2. Use leaked UUIDs to access private resources.

### 58. Method-based authz bypass

- **Difficulty:** EASY
- **Slug:** `method-based-authz-bypass`
- **Source prompt:** If `GET /resource/1` is forbidden, try `POST`, `PUT`, `DELETE`, `PATCH`, `OPTIONS`. Also try `HEAD` for info disclosure.
- **Steps:**
  1. If `GET /resource/1` is forbidden, try `POST`, `PUT`, `DELETE`, `PATCH`, `OPTIONS`.
  2. Also try `HEAD` for info disclosure.

### 59. Mass assignment

- **Difficulty:** MED
- **Slug:** `mass-assignment`
- **Source prompt:** On profile/order update endpoints, add fields like `role:"admin"`, `isVerified:true`, `balance:99999`, `userId:<other>`. Report fields silently accepted.
- **Steps:**
  1. On profile/order update endpoints, add fields like `role:"admin"`, `isVerified:true`, `balance:99999`, `userId:<other>`.
  2. Report fields silently accepted.

### 60. IDOR via PATCH with foreign keys

- **Difficulty:** HARD
- **Slug:** `idor-via-patch-with-foreign-keys`
- **Source prompt:** On PATCH endpoints, change `owner_id`, `team_id`, `org_id` to another tenant's ID. Confirm cross-tenant write.
- **Steps:**
  1. On PATCH endpoints, change `owner_id`, `team_id`, `org_id` to another tenant's ID.
  2. Confirm cross-tenant write.

### 61. Force-browsing admin routes

- **Difficulty:** EASY
- **Slug:** `force-browsing-admin-routes`
- **Source prompt:** Brute force common admin paths (`/admin`, `/internal`, `/dashboard`, `/api/admin/*`) as a low-priv user. Diff with anonymous responses.
- **Steps:**
  1. Brute force common admin paths (`/admin`, `/internal`, `/dashboard`, `/api/admin/*`) as a low-priv user.
  2. Diff with anonymous responses.

### 62. Role downgrade via JSON

- **Difficulty:** MED
- **Slug:** `role-downgrade-via-json`
- **Source prompt:** On role assignment endpoints, try assigning `superadmin`, `owner`, `god`. Test casing and locale (`ADMIN`, `Admin `).
- **Steps:**
  1. On role assignment endpoints, try assigning `superadmin`, `owner`, `god`.
  2. Test casing and locale (`ADMIN`, `Admin `).

### 63. Tenant header confusion

- **Difficulty:** MED
- **Slug:** `tenant-header-confusion`
- **Source prompt:** Try `X-Tenant-Id`, `X-Org-Id`, `X-Account-Id` headers. Swap to another tenant's ID with your auth token.
- **Steps:**
  1. Try `X-Tenant-Id`, `X-Org-Id`, `X-Account-Id` headers.
  2. Swap to another tenant's ID with your auth token.

### 64. GraphQL node global ID guess

- **Difficulty:** MED
- **Slug:** `graphql-node-global-id-guess`
- **Source prompt:** Decode base64 GraphQL IDs (`User:1`), increment, re-encode, refetch.

### 65. IDOR in file storage URLs

- **Difficulty:** MED
- **Slug:** `idor-in-file-storage-urls`
- **Source prompt:** Direct S3/GCS/Azure URLs often have predictable paths. Enumerate `/uploads/{userId}/...`.
- **Steps:**
  1. Direct S3/GCS/Azure URLs often have predictable paths.
  2. Enumerate `/uploads/{userId}/...`.

### 66. Indirect IDOR via slugs

- **Difficulty:** MED
- **Slug:** `indirect-idor-via-slugs`
- **Source prompt:** If slugs are derived from titles, enumerate likely slugs of private docs (`/docs/q4-financials`).

### 67. IDOR in invitation tokens

- **Difficulty:** MED
- **Slug:** `idor-in-invitation-tokens`
- **Source prompt:** Test if invite tokens are predictable (short, sequential, time-based). Reuse expired tokens.
- **Steps:**
  1. Test if invite tokens are predictable (short, sequential, time-based).
  2. Reuse expired tokens.

### 68. Privilege check skipped on bulk endpoint

- **Difficulty:** HARD
- **Slug:** `privilege-check-skipped-on-bulk-endpoint`
- **Source prompt:** Bulk endpoints (`/batch`, `/bulk`) often skip per-item authz. Include a victim's ID in a batch update.
- **Steps:**
  1. Bulk endpoints (`/batch`, `/bulk`) often skip per-item authz.
  2. Include a victim's ID in a batch update.

### 69. GET-to-POST authz drift

- **Difficulty:** MED
- **Slug:** `get-to-post-authz-drift`
- **Source prompt:** If GET enforces authz but POST/PUT does not (or vice versa), find the inconsistent verb.

### 70. IDOR via export / download

- **Difficulty:** MED
- **Slug:** `idor-via-export-download`
- **Source prompt:** Export endpoints (`/export?ids=1,2,3`) sometimes accept other users' IDs. Verify per-ID checks.
- **Steps:**
  1. Export endpoints (`/export?ids=1,2,3`) sometimes accept other users' IDs.
  2. Verify per-ID checks.

## Additional coverage

- Blind, nested-object, bulk/export/download, GraphQL, WebSocket, and cross-tenant IDOR.
- Compare ownership and authorization at every nested resource boundary, not only the root object.
- Prove with two owned principals and the minimum synthetic record; do not enumerate identifiers.
