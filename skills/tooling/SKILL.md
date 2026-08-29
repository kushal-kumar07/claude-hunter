---
name: claude-bugbounty-tooling-skill
description: Choose the right security tool for recon, JS discovery, fuzzing, secret checks, and validation based on the current phase of testing.
---

# BUG BOUNTY TOOLING guidance

Use this skill when you need to choose the correct tool for the current phase of a web assessment. Keep the workflow simple: passive discovery first, then live validation, then focused exploitation or reporting.

## Operating rules

- Work only within authorized scope and test windows.
- Prefer safe, non-destructive probes and synthetic data.
- Keep concurrency and rate limits conservative.
- Validate each suspicion with a minimal live check before escalating.
- Redact secrets and personal data from notes and reports.

## Tool selection map

### 1. Domain and subdomain discovery
- `amass` — broad asset discovery, ASN mapping, and target expansion.
- `subfinder` — fast subdomain enumeration.
- `dnsx` — DNS validation and enumeration.
- `naabu` — port scanning and quick service discovery.
- `nmap` — deeper banner and service inspection.

Use when: the target is not yet mapped, you need hosts, ports, or hidden services.

### 2. HTTP and alive endpoint validation
- `httpx` — check which hosts and paths respond over HTTP/S.
- `curl` — manual verification and request replay.

Use when: you need to confirm whether a discovered host or route is live.

### 3. JS, archive, and endpoint discovery
- `gau` — gather URLs from archives and public sources.
- `waybackurls` — historical URL mining from Wayback.
- `linkfinder` — extract endpoints and parameters from JS/HTML.
- `hakrawler` — crawl pages and collect linked URLs.

Use when: looking for hidden APIs, stale routes, old endpoints, or client-side secrets.

### 4. Directory and endpoint fuzzing
- `ffuf` — fastest general-purpose fuzzing for directories, files, and routes.
- `dirsearch` — classic directory/file brute-force.
- `gobuster` — lightweight directory enumeration.
- `feroxbuster` — fast recursive directory discovery.
- `wfuzz` — parameter and request fuzzing for custom logic.

Use when: you need to find hidden files, endpoints, API paths, or parameter variations.

### 5. Vulnerability and scanning checks
- `nuclei` — fast template-based checks for known issues.
- `dalfox` — XSS-focused scanning and payload testing.
- `sqlmap` — SQL injection testing.

Use when: you want broad vulnerability detection or a focused scanner for a class of bug.

### 6. Secret and config leak checks
- `trufflehog` — secret scanning in repos, files, and artifacts.
- `gitleaks` — repository and secret detection.
- `secretfinder` — JS/HTML-oriented secret search.
- `git-dumper` — grab exposed `.git` metadata from accessible repos.

Use when: reviewing public assets, JS bundles, source maps, or exposed git metadata for secrets.

## Best default workflow

1. Run `amass` and `subfinder` for asset discovery.
2. Validate with `httpx` and `naabu`.
3. Mine JS and archives with `gau`, `waybackurls`, `linkfinder`, and `hakrawler`.
4. Use `ffuf` or `dirsearch` to enumerate likely paths.
5. Run `nuclei` and `dalfox` for targeted checks.
6. Use `trufflehog`, `gitleaks`, and `secretfinder` for secret exposure review.
7. Confirm only after a minimal, safe check and document evidence.

## When to invoke this skill

Invoke this skill when:
- the user asks which tool to use for a phase of testing
- a target is not yet mapped and the next step is unclear
- the workflow needs a quick decision on recon vs fuzzing vs scanning vs secret review
- a report or checklist needs to be generated from the installed tool stack

## Example prompts

- "Use the tooling skill. We have an unauthenticated target and need the fastest recon path. Tell me which tools to run first and why."
- "Use the tooling skill and recommend the best tools for JS endpoint discovery, directory fuzzing, and secret scanning."
- "Use the tooling skill to build a bug bounty workflow for an app with hidden admin routes and possible API leaks."

## Recommended tool stack for common jobs

- Recon: `amass`, `subfinder`, `httpx`, `naabu`
- JS discovery: `gau`, `waybackurls`, `linkfinder`, `hakrawler`
- Directory discovery: `ffuf`, `dirsearch`, `gobuster`, `feroxbuster`
- Vulnerability checks: `nuclei`, `dalfox`, `sqlmap`
- Secret review: `trufflehog`, `gitleaks`, `secretfinder`, `git-dumper`
