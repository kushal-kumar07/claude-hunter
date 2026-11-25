---
name: claude-takeover-security-skill
description: Assess dangling DNS, cloud, and hosted-service references for subdomain or resource takeover risk.
---

# TAKEOVER security assessment

Assess dangling DNS, cloud, and hosted-service references for subdomain or resource takeover risk.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **TAKEOVER** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** The tester can claim an unclaimed resource (a dangling CNAME target, an abandoned package name, an unclaimed account) and serve content as its legitimate owner.
- **False positive when:** The resource returns a provider's generic not-found page that does not indicate the name is actually claimable, or it is already correctly claimed.

## Prompt catalog

### 193. Dangling DNS CNAME enumeration

- **Difficulty:** MED
- **Slug:** `dangling-dns-cname-enumeration`
- **Source prompt:** Enumerate all subdomains via crt.sh, Amass. Resolve each. Check CNAMEs pointing to GitHub Pages, S3, Heroku, Azure, Shopify with no claim.
- **Steps:**
  1. Enumerate all subdomains via crt.sh, Amass.
  2. Resolve each.
  3. Check CNAMEs pointing to GitHub Pages, S3, Heroku, Azure, Shopify with no claim.

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
