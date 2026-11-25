---
name: claude-xxe-security-skill
description: Assess XML parsing for external entity resolution, local file access, and server-side request behavior.
---

# XXE security assessment

Assess XML parsing for external entity resolution, local file access, and server-side request behavior.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **XXE** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** The XML parser resolves an external or parameter entity, proven by an out-of-band callback or disclosed file content, without requiring access the tester doesn't otherwise have.
- **False positive when:** The parser errors out before resolution, or entity expansion is disabled and the apparent anomaly is just a generic malformed-XML error.

## Prompt catalog

### 118. Classic XXE file read

- **Difficulty:** MED
- **Slug:** `classic-xxe-file-read`
- **Source prompt:** Send `<!DOCTYPE foo [<!ENTITY xxe SYSTEM "file:///etc/passwd">]><foo>&xxe;</foo>` to every XML endpoint.

### 119. Blind XXE via OOB

- **Difficulty:** HARD
- **Slug:** `blind-xxe-via-oob`
- **Source prompt:** Use external DTD to exfil data via DNS/HTTP to Burp Collaborator.

### 120. XXE via SVG / DOCX

- **Difficulty:** MED
- **Slug:** `xxe-via-svg-docx`
- **Source prompt:** Embed XXE in uploaded SVG, DOCX, XLSX. Test if processor expands entities.
- **Steps:**
  1. Embed XXE in uploaded SVG, DOCX, XLSX.
  2. Test if processor expands entities.

### 121. XXE in SOAP endpoints

- **Difficulty:** MED
- **Slug:** `xxe-in-soap-endpoints`
- **Source prompt:** Probe SOAP `.asmx`, `.svc` endpoints with XXE payloads.

### 122. XInclude bypass

- **Difficulty:** HARD
- **Slug:** `xinclude-bypass`
- **Source prompt:** If `DOCTYPE` is blocked, try `<xi:include href="..."/>`.

### 123. XXE in PDF parsers

- **Difficulty:** HARD
- **Slug:** `xxe-in-pdf-parsers`
- **Source prompt:** Some PDF generators expand XML metadata. Test XMP injection.
- **Steps:**
  1. Some PDF generators expand XML metadata.
  2. Test XMP injection.

## Additional coverage

- Blind and error-based XXE using an owned, non-sensitive callback.
- XInclude injection and parser-specific external-entity behavior.
- XXE through SVG, DOCX, SOAP, REST, and upload-processing pipelines.
- Encoding and filter-bypass differentials across parser layers.
