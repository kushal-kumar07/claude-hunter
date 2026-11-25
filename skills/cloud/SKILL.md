---
name: claude-cloud-security-skill
description: Assess cloud identity, metadata, storage, orchestration, and exposed service controls.
---

# CLOUD security assessment

Assess cloud identity, metadata, storage, orchestration, and exposed service controls.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **CLOUD** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** A cloud resource, metadata endpoint, or IAM boundary is reachable or misconfigured in a way that discloses credentials or lets an action cross a tenant/account boundary.
- **False positive when:** The resource is intentionally public, or access required credentials already obtained through an unrelated compromise outside scope.

## Prompt catalog

### 210. S3 bucket public read/write

- **Difficulty:** EASY
- **Slug:** `s3-bucket-public-read-write`
- **Source prompt:** Enumerate buckets via tool like `s3scanner`. Test anonymous `s3:ListBucket`, `s3:GetObject`, `s3:PutObject`, `s3:GetBucketAcl`.
- **Steps:**
  1. Enumerate buckets via tool like `s3scanner`.
  2. Test anonymous `s3:ListBucket`, `s3:GetObject`, `s3:PutObject`, `s3:GetBucketAcl`.

### 211. IAM role over-privilege

- **Difficulty:** MED
- **Slug:** `iam-role-over-privilege`
- **Source prompt:** If you obtain AWS creds, run `enumerate-iam` / Pacu modules. Report `*:*` policies, dangerous trust relationships.
- **Steps:**
  1. If you obtain AWS creds, run `enumerate-iam` / Pacu modules.
  2. Report `*:*` policies, dangerous trust relationships.

### 212. EC2 metadata access via SSRF

- **Difficulty:** MED
- **Slug:** `ec2-metadata-access-via-ssrf`
- **Source prompt:** From any SSRF, hit `http://169.254.169.254/latest/meta-data/iam/security-credentials/`. Use creds to enumerate.
- **Steps:**
  1. From any SSRF, hit `http://169.254.169.254/latest/meta-data/iam/security-credentials/`.
  2. Use creds to enumerate.

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
- **Steps:**
  1. Probe `:6443/api`, `:10250/pods` (kubelet), `:2379` (etcd).
  2. Report exposed clusters.

### 216. Docker socket exposure

- **Difficulty:** HARD
- **Slug:** `docker-socket-exposure`
- **Source prompt:** Probe `:2375` (plain) and `:2376`. RCE via container create.
- **Steps:**
  1. Probe `:2375` (plain) and `:2376`.
  2. RCE via container create.

### 217. Public Elasticsearch / Mongo / Redis

- **Difficulty:** MED
- **Slug:** `public-elasticsearch-mongo-redis`
- **Source prompt:** Shodan-style scan for `:9200`, `:27017`, `:6379` exposed without auth.
