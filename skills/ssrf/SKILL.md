---
name: claude-ssrf-security-skill
description: Assess server-side request functionality for unintended access to internal, local, or cloud metadata services.
---

# SSRF security assessment

Assess server-side request functionality for unintended access to internal, local, or cloud metadata services.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **SSRF** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** The server itself issues a request to a tester-controlled address or internal resource, proven with an out-of-band callback (DNS/HTTP) or internal-only response content.
- **False positive when:** The request actually originates from the client/browser, the "proof" is just a redirect the browser follows, or an allowlist/firewall blocks the internal address despite an initially permissive-looking response.

## Prompt catalog

### 41. SSRF via URL parameter

- **Difficulty:** EASY
- **Slug:** `ssrf-via-url-parameter`
- **Source prompt:** Find every parameter that accepts a URL (`?url=`, `?image=`, `?webhook=`, `?callback=`). Replace with `http://169.254.169.254/latest/meta-data/` (AWS), `http://metadata.google.internal/`, `http://localhost:22`. Report responses.
- **Steps:**
  1. Find every parameter that accepts a URL (`?url=`, `?image=`, `?webhook=`, `?callback=`).
  2. Replace with `http://169.254.169.254/latest/meta-data/` (AWS), `http://metadata.google.internal/`, `http://localhost:22`.
  3. Report responses.

### 42. Blind SSRF via webhook

- **Difficulty:** MED
- **Slug:** `blind-ssrf-via-webhook`
- **Source prompt:** If the app sends webhooks, point them at a Burp Collaborator URL. Note any leaked headers (auth, internal hostnames).
- **Steps:**
  1. If the app sends webhooks, point them at a Burp Collaborator URL.
  2. Note any leaked headers (auth, internal hostnames).

### 43. SSRF via PDF generator

- **Difficulty:** HARD
- **Slug:** `ssrf-via-pdf-generator`
- **Source prompt:** Upload HTML to PDF endpoints with `<iframe src="http://169.254.169.254/...">` or `<img src="file:///etc/passwd">`. wkhtmltopdf and Chromium-based generators often leak.
- **Steps:**
  1. Upload HTML to PDF endpoints with `<iframe src="http://169.254.169.254/...">` or `<img src="file:///etc/passwd">`.
  2. wkhtmltopdf and Chromium-based generators often leak.

### 44. SSRF via image proxy

- **Difficulty:** HARD
- **Slug:** `ssrf-via-image-proxy`
- **Source prompt:** Submit `http://localhost:6379/` (Redis), `gopher://localhost:6379/_...` to image fetchers. Report any non-image content returned.
- **Steps:**
  1. Submit `http://localhost:6379/` (Redis), `gopher://localhost:6379/_...` to image fetchers.
  2. Report any non-image content returned.

### 45. SSRF via DNS rebinding

- **Difficulty:** HARD
- **Slug:** `ssrf-via-dns-rebinding`
- **Source prompt:** Submit `http://rebind.it/<vps-ip>` or set up your own rebinder. Confirm whether the validator and fetcher resolve at different times.
- **Steps:**
  1. Submit `http://rebind.it/<vps-ip>` or set up your own rebinder.
  2. Confirm whether the validator and fetcher resolve at different times.

### 46. SSRF via redirect chain

- **Difficulty:** MED
- **Slug:** `ssrf-via-redirect-chain`
- **Source prompt:** Submit an attacker-controlled URL that 302s to `http://169.254.169.254/`. Many fetchers validate the first URL only.
- **Steps:**
  1. Submit an attacker-controlled URL that 302s to `http://169.254.169.254/`.
  2. Many fetchers validate the first URL only.

### 47. SSRF via SVG external entities

- **Difficulty:** MED
- **Slug:** `ssrf-via-svg-external-entities`
- **Source prompt:** Upload SVG referencing `<image href="http://internal-host/">`. Check if the rasterizer fetches it.
- **Steps:**
  1. Upload SVG referencing `<image href="http://internal-host/">`.
  2. Check if the rasterizer fetches it.

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
- **Steps:**
  1. Some importers accept remote URLs.
  2. Probe with internal addresses and exotic schemes (`file:`, `ftp:`, `dict:`).

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
- **Steps:**
  1. Some OAuth servers fetch the redirect_uri for validation.
  2. Try internal addresses.

### 55. SSRF via Kubernetes API

- **Difficulty:** HARD
- **Slug:** `ssrf-via-kubernetes-api`
- **Source prompt:** Target `https://kubernetes.default.svc/api/` and `http://169.254.169.254/` from in-cluster pods reachable via SSRF.

## Additional coverage

- DNS rebinding and redirect-chain behavior.
- IPv6, alternate IP encodings, decimal/octal forms, and URL-parser confusion.
- SSRF through PDF, image, document, webhook, and other server-side processors.
- Validate internal reachability with an owned canary service; never retrieve real metadata or
  credentials.
