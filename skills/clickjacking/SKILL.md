---
name: claude-clickjacking-security-skill
description: Assess whether sensitive web actions can be framed and triggered through UI redressing.
---

# Clickjacking assessment

Determine whether an attacker-controlled origin can frame a sensitive authenticated page and cause
a state-changing action.

## Safe workflow

1. Use an owned test account and identify sensitive actions such as email/password changes,
   payments, role changes, OAuth consent, or account deletion.
2. Inspect `Content-Security-Policy: frame-ancestors` and `X-Frame-Options` as screening signals.
3. Build a local proof page with a visible, non-destructive canary action. Confirm the target
   actually renders in a cross-origin iframe.
4. Verify frame-busting logic, `Sec-Fetch-*` handling, and SameSite cookie behavior.
5. Do not perform a real transfer, deletion, privilege change, or consent action.

## Finding threshold

Missing headers alone are not sufficient. A valid finding requires browser evidence that a
cross-origin frame loads and a sensitive state-changing action remains reachable in that context.
Read-only or public marketing pages should generally be informational.

## Remediation

Use an appropriate `frame-ancestors` policy, retain compatible `X-Frame-Options`, enforce
anti-CSRF protections, and test all sensitive flows in real browsers.

## Source attribution

- Adapted from `elementalsouls/Claude-BugHunter` `skills/hunt-clickjacking/SKILL.md`.
- Repository content license: CC BY 4.0.
