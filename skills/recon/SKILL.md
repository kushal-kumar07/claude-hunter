---
name: claude-recon-security-skill
description: Perform authorized asset discovery and attack-surface mapping to identify forgotten or exposed services.
---

# RECON security assessment

Perform authorized asset discovery and attack-surface mapping to identify forgotten or exposed services.

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

Use the prompts below to guide a focused **RECON** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Prompt catalog

### 269. Subdomain enumeration

- **Difficulty:** EASY
- **Slug:** `subdomain-enumeration`
- **Source prompt:** Run `subfinder` + `amass` + `assetfinder` + crt.sh + dnsx. Probe live with `httpx`. Output list.

### 270. JS endpoint extraction

- **Difficulty:** EASY
- **Slug:** `js-endpoint-extraction`
- **Source prompt:** Crawl all JS bundles. Extract URLs/paths with `linkfinder` / `gau`. Build endpoint inventory.

### 271. Wayback / archive mining

- **Difficulty:** EASY
- **Slug:** `wayback-archive-mining`
- **Source prompt:** Pull URLs from Wayback (`gau`, `waybackurls`). Probe for live old endpoints.

### 272. Certificate transparency

- **Difficulty:** EASY
- **Slug:** `certificate-transparency`
- **Source prompt:** Pull all certs for the org from crt.sh, censys, certspotter. Reveal staging/dev hosts.

### 273. GitHub dorking

- **Difficulty:** EASY
- **Slug:** `github-dorking`
- **Source prompt:** Search GitHub for the company domain, internal repo names, employee accounts. Find leaked secrets, dotfiles, deploy scripts.

### 274. Tech stack fingerprint

- **Difficulty:** EASY
- **Slug:** `tech-stack-fingerprint`
- **Source prompt:** Run `wappalyzer`, `whatweb`. Map frameworks, CDN, WAF. Note CVE-prone versions.

### 297. ASN / IP range mapping

- **Difficulty:** MED
- **Slug:** `asn-ip-range-mapping`
- **Source prompt:** Resolve the org's ASN via BGP lookup, enumerate every IP in range, port-scan with `naabu`/`masscan`. Identify forgotten services.

### 298. Favicon hash pivot

- **Difficulty:** MED
- **Slug:** `favicon-hash-pivot`
- **Source prompt:** Compute favicon mmh3 hash, search Shodan/Censys for matching hosts — finds shadow infra reusing the same favicon.

## Source attribution

- Source: [https://hackwithclaude.com/prompts](https://hackwithclaude.com/prompts)
- Retrieved: 2026-08-28
- Included prompts: 8
