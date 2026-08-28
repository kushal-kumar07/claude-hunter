---
name: claude-takeover-security-skill
description: Assess dangling DNS, cloud, and hosted-service references for subdomain or resource takeover risk.
---

# TAKEOVER security assessment

Assess dangling DNS, cloud, and hosted-service references for subdomain or resource takeover risk.

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

Use the prompts below to guide a focused **TAKEOVER** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Prompt catalog

### 193. Dangling DNS CNAME enumeration

- **Difficulty:** MED
- **Slug:** `dangling-dns-cname-enumeration`
- **Source prompt:** Enumerate all subdomains via crt.sh, Amass. Resolve each. Check CNAMEs pointing to GitHub Pages, S3, Heroku, Azure, Shopify with no claim.

### 194. Dangling S3 bucket

- **Difficulty:** MED
- **Slug:** `dangling-s3-bucket`
- **Source prompt:** For any subdomain CNAMEd to S3 returning NoSuchBucket, register the bucket.

### 195. GitHub Pages takeover

- **Difficulty:** MED
- **Slug:** `github-pages-takeover`
- **Source prompt:** Subdomain → github.io with `There isn't a GitHub Pages site here.` → register the repo.

### 196. Heroku takeover

- **Difficulty:** MED
- **Slug:** `heroku-takeover`
- **Source prompt:** Subdomain → herokudns.com with `no-such-app` → claim app name.

### 197. Azure takeover

- **Difficulty:** MED
- **Slug:** `azure-takeover`
- **Source prompt:** Check `azurewebsites.net`, `cloudapp.net`, `trafficmanager.net` dangling references.

## Source attribution

- Source: [https://hackwithclaude.com/prompts](https://hackwithclaude.com/prompts)
- Retrieved: 2026-08-28
- Included prompts: 5
