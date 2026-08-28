---
name: claude-html-injection-security-skill
description: Assess unsanitized HTML rendering, phishing, UI manipulation, and dangling markup.
---

# HTML injection assessment

Identify inputs rendered as markup without encoding or sanitization, even where script execution is
blocked. This is distinct from XSS: prove raw markup rendering first, then escalate only in an
authorized test environment.

## Safe workflow

1. Inventory search, profile, comments, errors, notifications, email previews, and admin views.
2. Submit a unique benign tag marker such as `<b>HTML-CANARY</b>` and inspect both response and
   rendered DOM.
3. Check stored and cross-user rendering, HTML email contexts, attribute contexts, and dangling
   markup using non-sensitive synthetic content.
4. If markup is accepted, separately test whether script-capable contexts are blocked; hand off
   confirmed execution to the XSS skill.
5. Do not collect credentials or send data to external infrastructure.

## Impact and remediation

Document phishing/UI manipulation, injected links/forms, notification or email reach, and any
content leakage. Encode output by context, sanitize with a maintained allowlist, isolate email
rendering, and add regression tests for stored and reflected contexts.

## Source attribution

- Adapted from `elementalsouls/Claude-BugHunter` `skills/hunt-html-injection/SKILL.md`.
- Repository content license: CC BY 4.0.
