---
name: claude-mobile-security-skill
description: Assess mobile application binaries, platform integrations, storage, transport, and WebView controls.
---

# MOBILE security assessment

Assess mobile application binaries, platform integrations, storage, transport, and WebView controls.

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

Use the prompts below to guide a focused **MOBILE** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Prompt catalog

### 204. APK static analysis

- **Difficulty:** EASY
- **Slug:** `apk-static-analysis`
- **Source prompt:** Decompile APK with jadx. Grep for hardcoded API keys, secrets, base URLs, debug flags, and crypto keys.

### 205. Cert pinning bypass test

- **Difficulty:** MED
- **Slug:** `cert-pinning-bypass-test`
- **Source prompt:** Run app under Frida with universal SSL unpinning. Inspect traffic for endpoints not in public docs.

### 206. Deep link abuse

- **Difficulty:** MED
- **Slug:** `deep-link-abuse`
- **Source prompt:** Enumerate exported activities and intent filters. Send crafted intents (`am start -a ... -d ...`) to access unauth screens.

### 207. iOS plist secrets

- **Difficulty:** MED
- **Slug:** `ios-plist-secrets`
- **Source prompt:** Inspect `Info.plist`, embedded provisioning profile, and `.app/Frameworks` for tokens.

### 208. WebView XSS / RCE

- **Difficulty:** HARD
- **Slug:** `webview-xss-rce`
- **Source prompt:** Find WebViews that load remote content. Test `javascript:` URLs, `addJavascriptInterface` exposed methods.

### 209. Insecure local storage

- **Difficulty:** MED
- **Slug:** `insecure-local-storage`
- **Source prompt:** Dump app's `/data/data/<pkg>/` (Android) or Keychain/Documents (iOS). Report plaintext PII, tokens, DBs.

## Source attribution

- Source: [https://hackwithclaude.com/prompts](https://hackwithclaude.com/prompts)
- Retrieved: 2026-08-28
- Included prompts: 6
