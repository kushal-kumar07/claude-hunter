---
name: claude-path-security-skill
description: Assess path and filename handling for traversal, normalization mismatches, and unintended file access.
---

# PATH security assessment

Assess path and filename handling for traversal, normalization mismatches, and unintended file access.

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

Use the prompts below to guide a focused **PATH** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Prompt catalog

### 182. Basic LFI probe

- **Difficulty:** EASY
- **Slug:** `basic-lfi-probe`
- **Source prompt:** On any path parameter, try `../../../../etc/passwd`, `..%2f..%2f..%2fetc/passwd`, `....//....//etc/passwd`, `%252e%252e/`.

### 183. Path traversal via filename

- **Difficulty:** MED
- **Slug:** `path-traversal-via-filename`
- **Source prompt:** Filenames in download endpoints often allow traversal. Try `../../boot.ini` (Windows), `../../etc/shadow`.

### 184. Symlink upload traversal

- **Difficulty:** HARD
- **Slug:** `symlink-upload-traversal`
- **Source prompt:** Upload a symlink (tar with symlink entry) that points outside intended dir.

### 185. Path traversal via Java/Spring

- **Difficulty:** HARD
- **Slug:** `path-traversal-via-java-spring`
- **Source prompt:** Test `;` and `%00` truncation; Spring's `org.springframework.web.util.UriUtils` edge cases.

### 186. S3/GCS path traversal

- **Difficulty:** MED
- **Slug:** `s3-gcs-path-traversal`
- **Source prompt:** If file keys are user-controlled, test `..` in keys, leading slashes, encoded dots.

### 187. Path normalization mismatch

- **Difficulty:** HARD
- **Slug:** `path-normalization-mismatch`
- **Source prompt:** Use `;`, `..;/`, `%2e%2e`, encoded slashes that decode after the auth layer (proxy vs. app).

## Source attribution

- Source: [https://hackwithclaude.com/prompts](https://hackwithclaude.com/prompts)
- Retrieved: 2026-08-28
- Included prompts: 6
