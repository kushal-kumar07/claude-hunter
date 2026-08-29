---
name: claude-archive-mining-security-skill
description: Mine public archives and historical URLs to uncover forgotten or reactivated web endpoints and API surfaces.
---

# ARCHIVE MINING security assessment

Use archived content, historical URLs, and public caches to identify old endpoints, removed pages, or routes that are still active and reachable.

## Operating rules

- Work only against systems, applications, accounts, and repositories where explicit authorization and a defined test window exist.
- Prefer local fixtures, staging environments, synthetic records, and non-destructive canaries. Do not access, alter, exfiltrate, or persist real user data.
- Establish rate, concurrency, payload-size, and stop limits before testing. Stop immediately if availability, confidentiality, or integrity could be affected.
- Treat a suspected issue as unconfirmed until the request, response, execution/data-flow evidence, affected principal, and security impact are recorded.
- Never use weaponized payloads when a harmless marker or controlled callback can demonstrate the same behavior.
- Redact secrets and personal data in notes. Report remediation guidance and the exact authorization scope alongside findings.

## Required tools

- `gau` — gather URLs from public sources and archives
- `waybackurls` — extract historical URLs from the Wayback Machine
- `httpx` — validate live archived endpoints
- `curl` — verify redirects, status codes, and auth flows
- `ffuf` — fuzz archived or candidate paths with safe, bounded rules
- `rg` / `grep` — filter output and search for interesting patterns
- `subfinder` or `amass` — optional host expansion and adjacent assets

## Assessment workflow

1. Define the target scope and define test limits.
2. Collect archived URLs for the domain, app, or service.
3. Deduplicate, normalize, and sort findings by path value and recurrence.
4. Determine which routes are still live, stale, or partially redirected.
5. Verify each candidate with safe probes and logs.
6. Report vulnerable endpoints with evidence, not just a raw URL list.

## Focus areas

- Legacy API routes
- Forgotten admin panels
- Old auth, reset, and callback endpoints
- Stale file or backup routes
- Shadow services discovered through historical URL patterns

## Prompt catalog

### 1. Wayback collection

- **Difficulty:** EASY
- **Slug:** `wayback-collection`
- **Source prompt:** Pull all historical URLs for the target domain with `waybackurls` and `gau`. Separate live checks from stale but still reachable paths.

### 2. Captured API path discovery

- **Difficulty:** EASY
- **Slug:** `captured-api-path-discovery`
- **Source prompt:** Review archived paths for `/api`, `/v1`, `/internal`, `/admin`, `/graphql`, and legacy route variants. Flag routes that still respond or redirect.

### 3. Forgotten admin panels

- **Difficulty:** MED
- **Slug:** `forgotten-admin-panels`
- **Source prompt:** Search historical URLs for admin, dashboard, login, billing, monitoring, or management pages that no longer appear in the active sitemap.

### 4. Redirect and misconfiguration drift

- **Difficulty:** MED
- **Slug:** `redirect-and-misconfiguration-drift`
- **Source prompt:** Compare historical and current endpoint responses to find redirects, rewritten paths, and stale behavior that does not match the current frontend.

### 5. Stale file and backup discovery

- **Difficulty:** MED
- **Slug:** `stale-file-and-backup-discovery`
- **Source prompt:** Mine archive data for `.bak`, `.old`, `.zip`, `.sql`, `.env`, `.yml`, or debug file patterns that may still be accessible.

## Source attribution

- Adapted from public archive-mining and historical recon workflows used in web bug bounty and asset discovery.
- This skill is intended only for authorized testing.
