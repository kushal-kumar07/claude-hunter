---
name: claude-grpc-security-skill
description: Assess gRPC reflection, authentication, metadata trust, transport, schema exposure, and gRPC-Web boundaries.
---

# gRPC security assessment

Assess externally reachable gRPC and gRPC-Web services, especially microservice endpoints assumed
to be internal.

## Safe workflow

1. Confirm scope for HTTP/2 ports and identify native gRPC, h2c, Envoy, or grpc-gateway behavior.
2. Check reflection and exposed proto descriptors as inventory signals; reflection alone is not
   automatically a vulnerability.
3. Call harmless read-only methods with no metadata, invalid metadata, and a test identity.
4. Compare edge and backend authorization, metadata stripping, tenant identity, and method-level
   permissions.
5. Check TLS/mTLS, plaintext exposure, transcoding validation, and schema leakage.
6. Do not invoke destructive methods or send Rapid Reset/DoS traffic without explicit written
   authorization.

## Evidence threshold

A finding needs an unauthorized successful method call, sensitive data exposure, spoofable
identity metadata, or a transport weakness with demonstrated confidentiality impact. Record gRPC
status codes, method path, metadata names (redacted), protocol, and identity context.

## Source attribution

- Adapted from `elementalsouls/Claude-BugHunter` `skills/hunt-grpc/SKILL.md`.
- Repository content license: CC BY 4.0.
