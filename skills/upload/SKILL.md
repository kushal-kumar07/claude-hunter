---
name: claude-upload-security-skill
description: Assess file upload validation, storage, retrieval, processing, and content handling controls.
---

# UPLOAD security assessment

Assess file upload validation, storage, retrieval, processing, and content handling controls.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **UPLOAD** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** A stored file is later served or executed in a way that breaks the intended content-type/execution boundary (runs as code, is served with attacker-controlled MIME from a trusted origin, overwrites another user's file).
- **False positive when:** The file uploads but is never retrievable, is correctly sandboxed or served with safe headers, or the path is only reachable with already-privileged access.

## Prompt catalog

### 96. Filetype extension bypass

- **Difficulty:** MED
- **Slug:** `filetype-extension-bypass`
- **Source prompt:** Upload `shell.php` as `shell.php.jpg`, `shell.pHp`, `shell.php%00.jpg`, `shell.php;.jpg`, `shell.phtml`, `shell.phar`. Report which are accepted.
- **Steps:**
  1. Upload `shell.php` as `shell.php.jpg`, `shell.pHp`, `shell.php%00.jpg`, `shell.php;.jpg`, `shell.phtml`, `shell.phar`.
  2. Report which are accepted.

### 97. Content-Type spoofing

- **Difficulty:** MED
- **Slug:** `content-type-spoofing`
- **Source prompt:** Upload a PHP/JSP shell with `Content-Type: image/jpeg` and a valid JPEG magic byte prefix. Test if server inspects content.
- **Steps:**
  1. Upload a PHP/JSP shell with `Content-Type: image/jpeg` and a valid JPEG magic byte prefix.
  2. Test if server inspects content.

### 98. Polyglot file (JPEG + PHP)

- **Difficulty:** HARD
- **Slug:** `polyglot-file-jpeg-php`
- **Source prompt:** Build a JPEG that is also a valid PHP script. Upload and request the file URL.
- **Steps:**
  1. Build a JPEG that is also a valid PHP script.
  2. Upload and request the file URL.

### 99. Upload to arbitrary path

- **Difficulty:** HARD
- **Slug:** `upload-to-arbitrary-path`
- **Source prompt:** Test if filename allows path traversal: `../../etc/passwd`, `..%2f..%2fshell.jsp`.

### 100. Zip slip

- **Difficulty:** HARD
- **Slug:** `zip-slip`
- **Source prompt:** Upload a zip with entries `../../../../etc/cron.d/x`. Test if extraction writes outside target dir.
- **Steps:**
  1. Upload a zip with entries `../../../../etc/cron.d/x`.
  2. Test if extraction writes outside target dir.

### 101. XXE via DOCX/XLSX upload

- **Difficulty:** HARD
- **Slug:** `xxe-via-docx-xlsx-upload`
- **Source prompt:** Modify DOCX `[Content_Types].xml` to include an XXE payload. Upload and observe metadata extraction.
- **Steps:**
  1. Modify DOCX `[Content_Types].xml` to include an XXE payload.
  2. Upload and observe metadata extraction.

### 102. SVG-based XSS / SSRF

- **Difficulty:** MED
- **Slug:** `svg-based-xss-ssrf`
- **Source prompt:** Upload SVG with `<script>` and `<image href="http://internal/">`. Report rendering and fetching behavior.
- **Steps:**
  1. Upload SVG with `<script>` and `<image href="http://internal/">`.
  2. Report rendering and fetching behavior.

### 103. Image bomb (decompression DoS)

- **Difficulty:** MED
- **Slug:** `image-bomb-decompression-dos`
- **Source prompt:** Upload a 100KB PNG that decompresses to 4GB. Test if the server crashes or freezes.
- **Steps:**
  1. Upload a 100KB PNG that decompresses to 4GB.
  2. Test if the server crashes or freezes.

### 104. EXIF/metadata XSS

- **Difficulty:** MED
- **Slug:** `exif-metadata-xss`
- **Source prompt:** Embed `<script>alert(1)</script>` in JPEG EXIF Comment. Test if any page renders EXIF unescaped.
- **Steps:**
  1. Embed `<script>alert(1)</script>` in JPEG EXIF Comment.
  2. Test if any page renders EXIF unescaped.

### 105. Unrestricted file size

- **Difficulty:** EASY
- **Slug:** `unrestricted-file-size`
- **Source prompt:** Upload a 10GB file. Test if server enforces size limits before reading the full body.
- **Steps:**
  1. Upload a 10GB file.
  2. Test if server enforces size limits before reading the full body.

### 106. Public access to uploaded files

- **Difficulty:** EASY
- **Slug:** `public-access-to-uploaded-files`
- **Source prompt:** After upload, fetch the file URL unauthenticated. Test from another user. Report missing access controls.
- **Steps:**
  1. After upload, fetch the file URL unauthenticated.
  2. Test from another user.
  3. Report missing access controls.

### 107. Race condition between upload and scan

- **Difficulty:** HARD
- **Slug:** `race-condition-between-upload-and-scan`
- **Source prompt:** Upload a malicious file, immediately request it before AV scan completes. Report if the file is served.
- **Steps:**
  1. Upload a malicious file, immediately request it before AV scan completes.
  2. Report if the file is served.

## Additional coverage

- Polyglot files, metadata handling, and filename normalization.
- Archive extraction and ZIP Slip path traversal.
- Extension, content-type, multipart, and parser discrepancies.
- Image/document processing chains, with execution tested only in an isolated fixture.
