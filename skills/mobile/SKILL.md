---
name: claude-mobile-security-skill
description: Assess mobile application binaries, platform integrations, storage, transport, and WebView controls.
---

# MOBILE security assessment

Assess mobile application binaries, platform integrations, storage, transport, and WebView controls.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **MOBILE** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** A binary, IPC channel, or storage location exposes data or logic to another app or a local attacker on a stock, non-rooted device matching the shipped build.
- **False positive when:** The issue only reproduces on a rooted/jailbroken device or a developer-only build flag absent from the shipped app.

## Prompt catalog

### 204. APK static analysis

- **Difficulty:** EASY
- **Slug:** `apk-static-analysis`
- **Source prompt:** Decompile APK with jadx. Grep for hardcoded API keys, secrets, base URLs, debug flags, and crypto keys.
- **Steps:**
  1. Decompile APK with jadx.
  2. Grep for hardcoded API keys, secrets, base URLs, debug flags, and crypto keys.

### 205. Cert pinning bypass test

- **Difficulty:** MED
- **Slug:** `cert-pinning-bypass-test`
- **Source prompt:** Run app under Frida with universal SSL unpinning. Inspect traffic for endpoints not in public docs.
- **Steps:**
  1. Run app under Frida with universal SSL unpinning.
  2. Inspect traffic for endpoints not in public docs.

### 206. Deep link abuse

- **Difficulty:** MED
- **Slug:** `deep-link-abuse`
- **Source prompt:** Enumerate exported activities and intent filters. Send crafted intents (`am start -a ... -d ...`) to access unauth screens.
- **Steps:**
  1. Enumerate exported activities and intent filters.
  2. Send crafted intents (`am start -a ... -d ...`) to access unauth screens.

### 207. iOS plist secrets

- **Difficulty:** MED
- **Slug:** `ios-plist-secrets`
- **Source prompt:** Inspect `Info.plist`, embedded provisioning profile, and `.app/Frameworks` for tokens.

### 208. WebView XSS / RCE

- **Difficulty:** HARD
- **Slug:** `webview-xss-rce`
- **Source prompt:** Find WebViews that load remote content. Test `javascript:` URLs, `addJavascriptInterface` exposed methods.
- **Steps:**
  1. Find WebViews that load remote content.
  2. Test `javascript:` URLs, `addJavascriptInterface` exposed methods.

### 209. Insecure local storage

- **Difficulty:** MED
- **Slug:** `insecure-local-storage`
- **Source prompt:** Dump app's `/data/data/<pkg>/` (Android) or Keychain/Documents (iOS). Report plaintext PII, tokens, DBs.
- **Steps:**
  1. Dump app's `/data/data/<pkg>/` (Android) or Keychain/Documents (iOS).
  2. Report plaintext PII, tokens, DBs.

