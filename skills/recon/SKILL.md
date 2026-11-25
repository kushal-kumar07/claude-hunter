---
name: claude-recon-security-skill
description: Perform authorized asset discovery and attack-surface mapping to identify forgotten or exposed services.
---

# RECON security assessment

Perform authorized asset discovery and attack-surface mapping to identify forgotten or exposed services.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **RECON** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** A discovered endpoint or asset is live, reachable, in scope, and its response confirms it belongs to the target.
- **False positive when:** The asset is stale or expired and no longer under the target's control, or it's a false DNS/certificate match to an unrelated third party.

## Prompt catalog

### 269. Subdomain enumeration

- **Difficulty:** EASY
- **Slug:** `subdomain-enumeration`
- **Source prompt:** Run `subfinder` + `amass` + `assetfinder` + crt.sh + dnsx. Probe live with `httpx`. Output list.
- **Steps:**
  1. Run `subfinder` + `amass` + `assetfinder` + crt.sh + dnsx.
  2. Probe live with `httpx`.
  3. Output list.

### 270. JS endpoint extraction

- **Difficulty:** EASY
- **Slug:** `js-endpoint-extraction`
- **Source prompt:** Crawl all JS bundles. Extract URLs/paths with `linkfinder` / `gau`. Build endpoint inventory.
- **Steps:**
  1. Crawl all JS bundles.
  2. Extract URLs/paths with `linkfinder` / `gau`.
  3. Build endpoint inventory.

### 271. Wayback / archive mining

- **Difficulty:** EASY
- **Slug:** `wayback-archive-mining`
- **Source prompt:** Pull URLs from Wayback (`gau`, `waybackurls`). Probe for live old endpoints.
- **Steps:**
  1. Pull URLs from Wayback (`gau`, `waybackurls`).
  2. Probe for live old endpoints.

### 272. Certificate transparency

- **Difficulty:** EASY
- **Slug:** `certificate-transparency`
- **Source prompt:** Pull all certs for the org from crt.sh, censys, certspotter. Reveal staging/dev hosts.
- **Steps:**
  1. Pull all certs for the org from crt.sh, censys, certspotter.
  2. Reveal staging/dev hosts.

### 273. GitHub dorking

- **Difficulty:** EASY
- **Slug:** `github-dorking`
- **Source prompt:** Search GitHub for the company domain, internal repo names, employee accounts. Find leaked secrets, dotfiles, deploy scripts.
- **Steps:**
  1. Search GitHub for the company domain, internal repo names, employee accounts.
  2. Find leaked secrets, dotfiles, deploy scripts.

### 274. Tech stack fingerprint

- **Difficulty:** EASY
- **Slug:** `tech-stack-fingerprint`
- **Source prompt:** Run `wappalyzer`, `whatweb`. Map frameworks, CDN, WAF. Note CVE-prone versions.
- **Steps:**
  1. Run `wappalyzer`, `whatweb`.
  2. Map frameworks, CDN, WAF.
  3. Note CVE-prone versions.

### 297. ASN / IP range mapping

- **Difficulty:** MED
- **Slug:** `asn-ip-range-mapping`
- **Source prompt:** Resolve the org's ASN via BGP lookup, enumerate every IP in range, port-scan with `naabu`/`masscan`. Identify forgotten services.
- **Steps:**
  1. Resolve the org's ASN via BGP lookup, enumerate every IP in range, port-scan with `naabu`/`masscan`.
  2. Identify forgotten services.

### 298. Favicon hash pivot

- **Difficulty:** MED
- **Slug:** `favicon-hash-pivot`
- **Source prompt:** Compute favicon mmh3 hash, search Shodan/Censys for matching hosts — finds shadow infra reusing the same favicon.
