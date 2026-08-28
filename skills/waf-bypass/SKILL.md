---
name: claude-waf-bypass-security-skill
description: Assess whether web application firewalls can be bypassed by alternate encodings, parser differentials, or transport variations.
---

# WAF bypass assessment

Assess whether an application firewall and the origin parse the same request consistently. A
successful bypass is only meaningful when it reaches a separately confirmed vulnerability or
security-control failure.

## Safe workflow

1. Confirm written authorization, target limits, request-rate limits, and a harmless canary.
2. Establish a blocked baseline and an equivalent benign request that is accepted.
3. Test one transformation at a time: URL, Unicode, HTML, double encoding, case, whitespace,
   comments, parameter pollution, alternate content types, headers, chunking, and HTTP/2
   normalization.
4. Compare WAF decision, origin response, status, body, timing, and logs. Do not infer a bypass
   from a different block page alone.
5. Validate only against a non-destructive lab payload or synthetic record. Never use bypasses to
   access real data, execute commands, evade monitoring, or degrade availability.
6. Record the original and transformed requests, decoding layers, WAF rule/result, origin behavior,
   and the smallest reproducible proof.

## Common differential areas

- URL and double-URL encoding, mixed case, Unicode normalization, and alternate delimiters.
- Comment/whitespace insertion and duplicate parameters or headers.
- `Content-Type`, method override, multipart, JSON, and parser disagreement.
- Transfer-Encoding/chunking and HTTP/2-to-HTTP/1.1 normalization.
- IP, host, and URL parser differences in SSRF and redirect controls.

## Finding threshold and remediation

Report a WAF bypass only when a protected, in-scope behavior is demonstrably reached through the
alternate representation. Tune canonicalization and validation at the application boundary,
normalize once before inspection, reject ambiguous requests, and regression-test WAF and origin
parsers together.

## Source attribution

- Adapted from `SnailSploit/Claude-Red` `Skills/web/offensive-waf-bypass/SKILL.md`.
- Source repository: https://github.com/SnailSploit/Claude-Red
