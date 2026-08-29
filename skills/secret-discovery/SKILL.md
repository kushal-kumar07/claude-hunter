---
name: claude-secret-discovery-security-skill
description: Find exposed credentials, API keys, tokens, and sensitive configuration clues in app code, source artifacts, and public discovery surfaces.
---

# SECRET DISCOVERY security assessment

Search for exposed credentials, tokens, API keys, and sensitive configuration values in live applications, archived content, source artifacts, JavaScript bundles, and deployment files.

## Operating rules

- Work only against systems, applications, accounts, and repositories where explicit authorization and a defined test window exist.
- Prefer local fixtures, staging environments, synthetic records, and non-destructive canaries. Do not access, alter, exfiltrate, or persist real user data.
- Establish rate, concurrency, payload-size, and stop limits before testing. Stop immediately if availability, confidentiality, or integrity could be affected.
- Treat a suspected issue as unconfirmed until the request, response, execution/data-flow evidence, affected principal, and security impact are recorded.
- Do not store or expose live secrets in notes, screenshots, or reports. Redact and rotate only through the authorized owner.
- Report remediation guidance and the exact authorization scope alongside findings.

## Required tools

- `trufflehog` — secret scanning across repos, files, and CI artifacts
- `gitleaks` — fast secret and credential detection
- `secretfinder` — basic secret search heuristic for app artifacts
- `rg` / `grep` — targeted secret-pattern scanning
- `curl` — fetch and inspect public or accessible files
- `httpx` — validate reachable endpoints and hosts
- `gau` / `waybackurls` — discover historical pages and files containing secrets
- `linkfinder` — inspect JS and HTML for embedded credentials and endpoints

## Assessment workflow

1. Define scope, environment, and authorization boundaries.
2. Review the app's public-facing files, JS bundles, source maps, and config surfaces.
3. Search for credential-like patterns and exposed keys in static assets and archived content.
4. Verify whether a secret is live, expired, or unused before reporting.
5. If exposure is confirmed, report the impact, exposure path, and remediation steps without disclosing the raw secret.

## Focus areas

- API keys and tokens in JS bundles
- Exposed `.env` or config files
- Git or CI leaks
- Source maps and build metadata leakage
- Public archives and old pages containing secrets
- Internal endpoints or auth patterns discovered through client-side code

## Prompt catalog

### 1. JS secret scanning

- **Difficulty:** EASY
- **Slug:** `js-secret-scanning`
- **Source prompt:** Search HTML, JS bundles, source maps, and static assets for API keys, tokens, JWTs, private URLs, and internal service credentials.

### 2. Public archive secret mining

- **Difficulty:** EASY
- **Slug:** `public-archive-secret-mining`
- **Source prompt:** Use `gau`, `waybackurls`, and other public archival sources to identify pages or asset names that may still reveal secret strings or config artifacts.

### 3. Exposed config and env files

- **Difficulty:** MED
- **Slug:** `exposed-config-and-env-files`
- **Source prompt:** Probe for `.env`, `config`, `secrets`, `settings`, and common framework metadata files; confirm exposure and list the leaked value categories without dumping the full secrets.

### 4. Git and CI leak review

- **Difficulty:** MED
- **Slug:** `git-and-ci-leak-review`
- **Source prompt:** Inspect public or exposed repositories, CI artifacts, and build outputs for credentials, tokens, and deploy secrets. Validate that the leakage is real and still active.

### 5. Source map and build metadata review

- **Difficulty:** MED
- **Slug:** `source-map-build-metadata-review`
- **Source prompt:** Inspect source maps and build metadata for secret-like strings, stale hostnames, internal service references, and credentials left in generated assets.

## Source attribution

- Adapted from public secret-discovery workflows used in web app review and source leak investigations.
- This skill is intended only for authorized testing and safe disclosure.
