---
name: claude-upload-security-skill
description: Assess file upload validation, storage, retrieval, processing, and content handling controls.
---

# UPLOAD security assessment

Assess file upload validation, storage, retrieval, processing, and content handling controls.

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

Use the prompts below to guide a focused **UPLOAD** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Prompt catalog

### 96. Filetype extension bypass

- **Difficulty:** MED
- **Slug:** `filetype-extension-bypass`
- **Source prompt:** Upload `shell.php` as `shell.php.jpg`, `shell.pHp`, `shell.php%00.jpg`, `shell.php;.jpg`, `shell.phtml`, `shell.phar`. Report which are accepted.

### 97. Content-Type spoofing

- **Difficulty:** MED
- **Slug:** `content-type-spoofing`
- **Source prompt:** Upload a PHP/JSP shell with `Content-Type: image/jpeg` and a valid JPEG magic byte prefix. Test if server inspects content.

### 98. Polyglot file (JPEG + PHP)

- **Difficulty:** HARD
- **Slug:** `polyglot-file-jpeg-php`
- **Source prompt:** Build a JPEG that is also a valid PHP script. Upload and request the file URL.

### 99. Upload to arbitrary path

- **Difficulty:** HARD
- **Slug:** `upload-to-arbitrary-path`
- **Source prompt:** Test if filename allows path traversal: `../../etc/passwd`, `..%2f..%2fshell.jsp`.

### 100. Zip slip

- **Difficulty:** HARD
- **Slug:** `zip-slip`
- **Source prompt:** Upload a zip with entries `../../../../etc/cron.d/x`. Test if extraction writes outside target dir.

### 101. XXE via DOCX/XLSX upload

- **Difficulty:** HARD
- **Slug:** `xxe-via-docx-xlsx-upload`
- **Source prompt:** Modify DOCX `[Content_Types].xml` to include an XXE payload. Upload and observe metadata extraction.

### 102. SVG-based XSS / SSRF

- **Difficulty:** MED
- **Slug:** `svg-based-xss-ssrf`
- **Source prompt:** Upload SVG with `<script>` and `<image href="http://internal/">`. Report rendering and fetching behavior.

### 103. Image bomb (decompression DoS)

- **Difficulty:** MED
- **Slug:** `image-bomb-decompression-dos`
- **Source prompt:** Upload a 100KB PNG that decompresses to 4GB. Test if the server crashes or freezes.

### 104. EXIF/metadata XSS

- **Difficulty:** MED
- **Slug:** `exif-metadata-xss`
- **Source prompt:** Embed `<script>alert(1)</script>` in JPEG EXIF Comment. Test if any page renders EXIF unescaped.

### 105. Unrestricted file size

- **Difficulty:** EASY
- **Slug:** `unrestricted-file-size`
- **Source prompt:** Upload a 10GB file. Test if server enforces size limits before reading the full body.

### 106. Public access to uploaded files

- **Difficulty:** EASY
- **Slug:** `public-access-to-uploaded-files`
- **Source prompt:** After upload, fetch the file URL unauthenticated. Test from another user. Report missing access controls.

### 107. Race condition between upload and scan

- **Difficulty:** HARD
- **Slug:** `race-condition-between-upload-and-scan`
- **Source prompt:** Upload a malicious file, immediately request it before AV scan completes. Report if the file is served.

## Source attribution

- Source: [https://hackwithclaude.com/prompts](https://hackwithclaude.com/prompts)
- Retrieved: 2026-08-28
- Included prompts: 12

## Additional coverage

- Polyglot files, metadata handling, and filename normalization.
- Archive extraction and ZIP Slip path traversal.
- Extension, content-type, multipart, and parser discrepancies.
- Image/document processing chains, with execution tested only in an isolated fixture.

### Source attribution

- Adapted from `SnailSploit/Claude-Red` `Skills/web/offensive-file-upload/SKILL.md`.
- Source repository: https://github.com/SnailSploit/Claude-Red
