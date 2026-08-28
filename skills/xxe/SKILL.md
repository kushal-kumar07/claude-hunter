---
name: claude-xxe-security-skill
description: Assess XML parsing for external entity resolution, local file access, and server-side request behavior.
---

# XXE security assessment

Assess XML parsing for external entity resolution, local file access, and server-side request behavior.

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

Use the prompts below to guide a focused **XXE** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

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

## Source attribution

- Source: [https://hackwithclaude.com/prompts](https://hackwithclaude.com/prompts)
- Retrieved: 2026-08-28
- Included prompts: 6

## Additional coverage

- Blind and error-based XXE using an owned, non-sensitive callback.
- XInclude injection and parser-specific external-entity behavior.
- XXE through SVG, DOCX, SOAP, REST, and upload-processing pipelines.
- Encoding and filter-bypass differentials across parser layers.

### Source attribution

- Adapted from `SnailSploit/Claude-Red` `Skills/web/offensive-xxe/SKILL.md`.
- Source repository: https://github.com/SnailSploit/Claude-Red
