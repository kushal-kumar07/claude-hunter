---
name: claude-cloud-security-skill
description: Assess cloud identity, metadata, storage, orchestration, and exposed service controls.
---

# CLOUD security assessment

Assess cloud identity, metadata, storage, orchestration, and exposed service controls.

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

Use the prompts below to guide a focused **CLOUD** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Prompt catalog

### 210. S3 bucket public read/write

- **Difficulty:** EASY
- **Slug:** `s3-bucket-public-read-write`
- **Source prompt:** Enumerate buckets via tool like `s3scanner`. Test anonymous `s3:ListBucket`, `s3:GetObject`, `s3:PutObject`, `s3:GetBucketAcl`.

### 211. IAM role over-privilege

- **Difficulty:** MED
- **Slug:** `iam-role-over-privilege`
- **Source prompt:** If you obtain AWS creds, run `enumerate-iam` / Pacu modules. Report `*:*` policies, dangerous trust relationships.

### 212. EC2 metadata access via SSRF

- **Difficulty:** MED
- **Slug:** `ec2-metadata-access-via-ssrf`
- **Source prompt:** From any SSRF, hit `http://169.254.169.254/latest/meta-data/iam/security-credentials/`. Use creds to enumerate.

### 213. GCP metadata token

- **Difficulty:** MED
- **Slug:** `gcp-metadata-token`
- **Source prompt:** Hit `http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token` with `Metadata-Flavor: Google`.

### 214. Azure managed identity token

- **Difficulty:** MED
- **Slug:** `azure-managed-identity-token`
- **Source prompt:** Hit `http://169.254.169.254/metadata/identity/oauth2/token` with `Metadata:true`.

### 215. Kubernetes anonymous API

- **Difficulty:** HARD
- **Slug:** `kubernetes-anonymous-api`
- **Source prompt:** Probe `:6443/api`, `:10250/pods` (kubelet), `:2379` (etcd). Report exposed clusters.

### 216. Docker socket exposure

- **Difficulty:** HARD
- **Slug:** `docker-socket-exposure`
- **Source prompt:** Probe `:2375` (plain) and `:2376`. RCE via container create.

### 217. Public Elasticsearch / Mongo / Redis

- **Difficulty:** MED
- **Slug:** `public-elasticsearch-mongo-redis`
- **Source prompt:** Shodan-style scan for `:9200`, `:27017`, `:6379` exposed without auth.

## Source attribution

- Source: [https://hackwithclaude.com/prompts](https://hackwithclaude.com/prompts)
- Retrieved: 2026-08-28
- Included prompts: 8
