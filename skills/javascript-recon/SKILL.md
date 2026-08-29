---
name: claude-javascript-recon-security-skill
description: Discover JavaScript files, hidden endpoints, and unauthenticated API surfaces from client-side code and public archives.
---

# JAVASCRIPT RECON security assessment

Discover JavaScript bundles, source maps, API references, and hidden endpoints embedded in client-side code before moving into deeper testing.

## Operating rules

- Work only against systems, applications, accounts, and repositories where explicit authorization and a defined test window exist.
- Prefer local fixtures, staging environments, synthetic records, and non-destructive canaries. Do not access, alter, exfiltrate, or persist real user data.
- Establish rate, concurrency, payload-size, and stop limits before testing. Stop immediately if availability, confidentiality, or integrity could be affected.
- Treat a suspected issue as unconfirmed until the request, response, execution/data-flow evidence, affected principal, and security impact are recorded.
- Prefer harmless markers, safe callbacks, and small live probes over intrusive payloads.
- Redact secrets and personal data in notes. Report remediation guidance and the exact authorization scope alongside findings.

## Required tools

- `gau` — collect URLs from archives and public sources
- `waybackurls` — archive endpoint extraction
- `linkfinder` — find endpoints and parameters in JS/HTML files
- `hakrawler` — spider targets for JS references and linked pages
- `httpx` — validate live hosts and HTTP endpoints
- `curl` — manual verification and request replay
- `rg` / `grep` — quick code scanning
- `ffuf` — optional endpoint fuzzing after discovery

## Assessment workflow

1. Define scope, identities, environment, test limits, and rollback contacts.
2. Identify the target app and root domains, then map reachable hosts and entry pages.
3. Pull URLs from archives, HTML, JavaScript bundles, and public source artifacts.
4. Filter for interesting APIs, admin routes, auth flows, and internal-only paths.
5. Live-check each endpoint with `httpx`, `curl`, and manual review.
6. Prioritize paths that reveal auth, tokens, internal services, or user-specific actions.
7. Capture evidence and proceed only with minimal, authorized, non-destructive validation.

## Focus areas

- Client-side endpoints hidden in bundled JS
- Legacy endpoints still exposed through archives
- API versioning clues and internal service names
- Sensitive routes embedded in source maps or static assets
- Unauthenticated or weakly-protected flows discovered from JS references

## Prompt catalog

### 1. JS bundle discovery

- **Difficulty:** EASY
- **Slug:** `js-bundle-discovery`
- **Source prompt:** Crawl the target, fetch all HTML and JS bundles, and enumerate any embedded API URLs, auth routes, and internal service names.

### 2. Link extraction from client-side code

- **Difficulty:** EASY
- **Slug:** `link-extraction-from-js`
- **Source prompt:** Use `linkfinder`, `gau`, and `waybackurls` to extract endpoints, parameters, and path assumptions from the app's JS assets.

### 3. Archive endpoint mining

- **Difficulty:** EASY
- **Slug:** `archive-endpoint-mining`
- **Source prompt:** Pull historic URLs from archives, then compare the old paths against the live site to find routes that still exist or have changed behavior.

### 4. Source map and build artifact review

- **Difficulty:** MED
- **Slug:** `source-map-build-artifact-review`
- **Source prompt:** Inspect source maps, JavaScript bundles, and asset manifests for hidden APIs, debug routes, leaked config, and outdated endpoint names.

### 5. Auth flow enumeration from JS

- **Difficulty:** MED
- **Slug:** `auth-flow-enumeration-from-js`
- **Source prompt:** Search client-side bundles for login, reset, MFA, callback, and token-refresh endpoints. Map how they accept and validate user input.

### 6. Admin / internal endpoint discovery

- **Difficulty:** MED
- **Slug:** `admin-internal-endpoint-discovery`
- **Source prompt:** Identify endpoints from JS references that look admin-only, internal, or meant for privileged users. Review access controls and route exposure.

## Source attribution

- Adapted from general JavaScript recon and archive-mining workflows used in web bug bounty and security research.
- This skill is intentionally framed for authorized testing only.
