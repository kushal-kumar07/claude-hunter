---
name: claude-http-smuggling-security-skill
description: Assess HTTP request desynchronization between clients, proxies, CDNs, and origin servers.
---

# HTTP request smuggling assessment

Identify disagreement between HTTP/1.1 or HTTP/2 layers about request boundaries. Prioritize safe
detection and never attempt credential capture, cache poisoning, or availability-impacting tests
without explicit written authorization.

## Safe workflow

1. Confirm the authorized proxy/CDN/origin topology and whether HTTP/2 is supported.
2. Fingerprint response behavior and reject malformed-header probes before testing a body-boundary
   canary.
3. Use a dedicated staging origin or an instrumented canary endpoint. Do not target another user's
   connection or send a payload that can remain queued for a victim.
4. Compare `Content-Length` and `Transfer-Encoding` parsing, HTTP/2 downgrade behavior, duplicate
   headers, whitespace, and connection reuse.
5. Treat timing alone as inconclusive. Confirm that a controlled second request is affected on a
   separate test session.
6. Record front-end and back-end identities, protocol versions, sanitized raw requests, timing,
   response pairing, and exact isolation controls.

## Detection areas

- CL.TE and TE.CL disagreement in HTTP/1.1.
- H2.CL and H2.TE downgrade inconsistencies.
- Duplicate or obfuscated `Transfer-Encoding` handling.
- HTTP/2-to-HTTP/1.1 translation and connection reuse.
- Cache, authentication, routing, or response-queue impact only after a safe parser finding.

## Validation gate

A parser discrepancy is not by itself a high-impact finding. Confirm a cross-request effect using
two owned sessions and a harmless marker. Do not harvest cookies, bypass access controls, poison a
shared cache, or load-test the service. Recommend strict RFC-compliant parsing, consistent proxy
and origin configuration, HTTP/2 downgrade hardening, and connection isolation.

## Source attribution

- Adapted from `elementalsouls/Claude-BugHunter` `skills/hunt-http-smuggling/SKILL.md`.
- Repository content license: CC BY 4.0.
