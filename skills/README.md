# Skills index

This folder contains the security skill packs used by Claude Code and Codex for authorized web application testing.

## Shared rules

- testing-rules: authorization rules, assessment workflow, and finding format that every category skill links to. It installs alongside them, so keep it installed.

## Orchestrator

- hunter: maps the attack surface of a URL, source code, or both, then proposes and auto-loads the relevant category skills below. Start here if you're unsure which skill(s) a target needs.

## Core categories

- api
- auth
- cache
- clickjacking
- cloud
- cmdi
- cors
- crypto
- csrf
- deserialization
- disclosure
- dos
- graphql
- grpc
- headers
- html-injection
- http-smuggling
- idor
- jwt
- ldap
- llm
- logic
- mobile
- nosql
- oauth
- path
- proto
- race
- rce
- recon
- redirect
- sqli
- ssrf
- ssti
- supply
- takeover
- upload
- waf-bypass
- websocket
- xss
- xxe

## JavaScript, secret discovery, and tooling additions

- archive-mining
- javascript-recon
- secret-discovery
- tooling

These four skills focus on the discovery side of web testing:

- JavaScript bundle analysis and endpoint extraction
- Historical URL mining from public archives
- Exposed secrets, keys, config artifacts, and source-map leaks
- Choosing the right tool for the correct stage of the assessment

## Tools commonly used with these skills

- `gau`
- `waybackurls`
- `linkfinder`
- `hakrawler`
- `trufflehog`
- `gitleaks`
- `secretfinder`
- `httpx`
- `ffuf`
- `curl`

Use only with explicit authorization, and keep requests safe, limited, and non-destructive.
