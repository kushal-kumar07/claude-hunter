---
name: claude-path-security-skill
description: Assess path and filename handling for traversal, normalization mismatches, and unintended file access.
---

# PATH security assessment

Assess path and filename handling for traversal, normalization mismatches, and unintended file access.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **PATH** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** Traversal sequences in a file/path parameter return content from outside the sanctioned directory, proven with a known file whose content is unique to that location.
- **False positive when:** The server normalizes the path server-side and returns only in-scope content, or it returns a generic not-found regardless of traversal depth.

## Prompt catalog

### 182. Basic LFI probe

- **Difficulty:** EASY
- **Slug:** `basic-lfi-probe`
- **Source prompt:** On any path parameter, try `../../../../etc/passwd`, `..%2f..%2f..%2fetc/passwd`, `....//....//etc/passwd`, `%252e%252e/`.

### 183. Path traversal via filename

- **Difficulty:** MED
- **Slug:** `path-traversal-via-filename`
- **Source prompt:** Filenames in download endpoints often allow traversal. Try `../../boot.ini` (Windows), `../../etc/shadow`.
- **Steps:**
  1. Filenames in download endpoints often allow traversal.
  2. Try `../../boot.ini` (Windows), `../../etc/shadow`.

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
- **Steps:**
  1. Use `;`, `..;/`, `%2e%2e`, encoded slashes that decode after the auth layer (proxy vs.
  2. app).

