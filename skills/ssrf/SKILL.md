---
name: claude-ssrf-security-skill
description: Assess server-side request functionality for unintended access to internal, local, or cloud metadata services.
---

# SSRF security assessment

Assess server-side request functionality for unintended access to internal, local, or cloud metadata services.

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

Use the prompts below to guide a focused **SSRF** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Prompt catalog

### 41. SSRF via URL parameter

- **Difficulty:** EASY
- **Slug:** `ssrf-via-url-parameter`
- **Source prompt:** Find every parameter that accepts a URL (`?url=`, `?image=`, `?webhook=`, `?callback=`). Replace with `http://169.254.169.254/latest/meta-data/` (AWS), `http://metadata.google.internal/`, `http://localhost:22`. Report responses.

### 42. Blind SSRF via webhook

- **Difficulty:** MED
- **Slug:** `blind-ssrf-via-webhook`
- **Source prompt:** If the app sends webhooks, point them at a Burp Collaborator URL. Note any leaked headers (auth, internal hostnames).

### 43. SSRF via PDF generator

- **Difficulty:** HARD
- **Slug:** `ssrf-via-pdf-generator`
- **Source prompt:** Upload HTML to PDF endpoints with `<iframe src="http://169.254.169.254/...">` or `<img src="file:///etc/passwd">`. wkhtmltopdf and Chromium-based generators often leak.

### 44. SSRF via image proxy

- **Difficulty:** HARD
- **Slug:** `ssrf-via-image-proxy`
- **Source prompt:** Submit `http://localhost:6379/` (Redis), `gopher://localhost:6379/_...` to image fetchers. Report any non-image content returned.

### 45. SSRF via DNS rebinding

- **Difficulty:** HARD
- **Slug:** `ssrf-via-dns-rebinding`
- **Source prompt:** Submit `http://rebind.it/<vps-ip>` or set up your own rebinder. Confirm whether the validator and fetcher resolve at different times.

### 46. SSRF via redirect chain

- **Difficulty:** MED
- **Slug:** `ssrf-via-redirect-chain`
- **Source prompt:** Submit an attacker-controlled URL that 302s to `http://169.254.169.254/`. Many fetchers validate the first URL only.

### 47. SSRF via SVG external entities

- **Difficulty:** MED
- **Slug:** `ssrf-via-svg-external-entities`
- **Source prompt:** Upload SVG referencing `<image href="http://internal-host/">`. Check if the rasterizer fetches it.

### 48. SSRF in SAML / OIDC metadata URLs

- **Difficulty:** HARD
- **Slug:** `ssrf-in-saml-oidc-metadata-urls`
- **Source prompt:** If the app fetches IdP metadata from a user-supplied URL, point it at internal services.

### 49. SSRF via Slack/Discord previews

- **Difficulty:** MED
- **Slug:** `ssrf-via-slack-discord-previews`
- **Source prompt:** Force the unfurl/preview service to hit internal services; check returned previews for leaked content.

### 50. SSRF via CSV/XLSX import URLs

- **Difficulty:** MED
- **Slug:** `ssrf-via-csv-xlsx-import-urls`
- **Source prompt:** Some importers accept remote URLs. Probe with internal addresses and exotic schemes (`file:`, `ftp:`, `dict:`).

### 51. Bypass IP filter with decimals/hex

- **Difficulty:** MED
- **Slug:** `bypass-ip-filter-with-decimals-hex`
- **Source prompt:** Try `http://2130706433/`, `http://0x7f000001/`, `http://0177.0.0.1/`, `http://127.1/`, `http://[::1]/`, `http://[::ffff:127.0.0.1]/`.

### 52. SSRF to internal admin panels

- **Difficulty:** MED
- **Slug:** `ssrf-to-internal-admin-panels`
- **Source prompt:** Enumerate common internal ports through SSRF: 80, 443, 8080, 8443, 8500 (Consul), 8080 (Jenkins), 9200 (ES), 5601 (Kibana), 2375 (Docker).

### 53. SSRF via XML external entity

- **Difficulty:** HARD
- **Slug:** `ssrf-via-xml-external-entity`
- **Source prompt:** Send `<!ENTITY xxe SYSTEM "http://internal/">` and observe out-of-band hit.

### 54. SSRF via OAuth `redirect_uri`

- **Difficulty:** HARD
- **Slug:** `ssrf-via-oauth-redirect-uri`
- **Source prompt:** Some OAuth servers fetch the redirect_uri for validation. Try internal addresses.

### 55. SSRF via Kubernetes API

- **Difficulty:** HARD
- **Slug:** `ssrf-via-kubernetes-api`
- **Source prompt:** Target `https://kubernetes.default.svc/api/` and `http://169.254.169.254/` from in-cluster pods reachable via SSRF.

## Source attribution

- Source: [https://hackwithclaude.com/prompts](https://hackwithclaude.com/prompts)
- Retrieved: 2026-08-28
- Included prompts: 15

## Additional coverage

- DNS rebinding and redirect-chain behavior.
- IPv6, alternate IP encodings, decimal/octal forms, and URL-parser confusion.
- SSRF through PDF, image, document, webhook, and other server-side processors.
- Validate internal reachability with an owned canary service; never retrieve real metadata or
  credentials.

### Source attribution

- Adapted from `SnailSploit/Claude-Red` `Skills/web/offensive-ssrf/SKILL.md`.
- Source repository: https://github.com/SnailSploit/Claude-Red
