---
name: claude-hunter-orchestrator-skill
description: Map the attack surface of a URL, source code, or both, then propose and auto-load the right claude-hunter category skills to test it. Use this first for any new target instead of picking a category skill by hand.
---

# HUNTER orchestrator

Given a target — a URL, pasted or linked source code, or both — this skill maps the attack
surface, turns what it finds into a short ranked list of relevant claude-hunter category skills,
confirms the plan with the user, then loads and runs those skills. It does not replace the
category skills; it decides which ones apply and in what order, and leans on `recon`,
`javascript-recon`, `disclosure`, `secret-discovery`, and `tooling` for the mapping work itself
rather than duplicating their logic.

## Shared rules

Load [testing-rules](../testing-rules/SKILL.md) first, every time, before any other step. Do not
run active or live probing until scope and authorization are confirmed per that skill's workflow.
Passive mapping of source code the user owns or pasted does not need a separate confirmation;
anything that touches a live host over the network does.

## Step 1 — Identify the input

Read the user's prompt and classify what was actually given:

- **URL only** — a live target with no source attached. Mapping is live recon.
- **Source code only** — a repo path, pasted files, or a diff, with no live target implied.
  Mapping is static.
- **Both** — a URL plus its source (or enough of it to be useful). Map both and correlate:
  routes found in code should be checked for live reachability; endpoints found live should be
  traced back to the handling code when possible.

If it's ambiguous which mode applies (e.g., a bare domain name with no stated intent), ask once
rather than guessing — do not spend tool calls probing a target you haven't confirmed is in scope.

## Step 2 — Confirm scope and authorization

Before any live request, confirm (per `testing-rules`): the exact host(s)/path(s) in scope, the
authorization basis (bug bounty program, pentest engagement, the user's own staging/local app),
test account(s) and environment, and any rate/concurrency limits. For a source-only review of
the user's own repo, skip the live-authorization question but still confirm you're not about to
run anything destructive against a real database or production config found in that code.

## Step 3 — Map the attack surface

Run whichever playbook (or both) applies. Keep this phase passive/read-only by default; only
escalate to active probing (fuzzing, auth-bypass attempts, payload injection) once scope is
confirmed and the user has picked specific skills to run in Step 6 — mapping itself should not
trigger alerts or change state.

### 3a. Live URL playbook

Use `recon`'s prompt catalog as the baseline and `tooling` to pick the concrete commands. At
minimum:

- Tech fingerprint: server/framework headers, `wappalyzer`/`whatweb`, response quirks.
- Security headers: CSP, `X-Frame-Options`, `Set-Cookie` flags, CORS headers (`headers`).
- Endpoint inventory: crawl the app, pull linked JS bundles (`javascript-recon`), mine archives
  if the target is broad enough to justify it (`archive-mining`).
- Auth surface: login/register/reset/MFA flows present, session cookie vs. bearer token vs. JWT,
  OAuth/SSO redirects.
- Exposed artifacts: `.git`, backups, source maps, debug endpoints, stack traces (`disclosure`,
  `secret-discovery`).
- API shape: REST paths and versions, GraphQL (`/graphql`, introspection), gRPC/protobuf,
  WebSocket upgrades.
- Only go beyond passive fingerprinting (e.g., directory fuzzing with `ffuf`) once scope and
  rate limits from Step 2 are explicit.

### 3b. Source code playbook

Walk the repo (or pasted files) for structural signals rather than reading every line:

- Routing layer: frameworks' route/controller definitions, path params, HTTP methods allowed.
- Data layer: raw query building vs. parameterized queries/ORM, NoSQL driver calls, LDAP query
  construction.
- Rendering: templating engine(s) in use and whether user input reaches them unescaped.
- Serialization: `pickle`/Java serialization/PHP `unserialize`/`yaml.load`-style calls on
  untrusted input.
- Auth/session code: how sessions, JWTs, or OAuth tokens are issued, validated, and scoped.
- File handling: upload endpoints, path-building from user input, archive extraction.
- Outbound requests: server-side fetch/import/proxy calls that take a user-supplied URL.
- Crypto usage: custom or weak algorithms, static IVs/keys, predictable token generation.
- Dependencies and CI/CD: `package.json`/`requirements.txt`/`pom.xml`/lockfiles, GitHub Actions
  or other pipeline config, Dockerfiles/IaC.
- Secrets: hardcoded keys, `.env` files committed, cloud credentials.
- AI/LLM integration: prompt construction, RAG retrieval, agent/tool-calling code.

### 3c. Both

Run 3a and 3b, then cross-reference: confirm routes found in code are actually reachable, and
check whether live-discovered endpoints match something in the source you can trace to a sink.

## Step 4 — Summarize the surface map

Before suggesting anything, give the user a short, concrete summary — not a dump of raw recon
output. Cover: stack/framework, auth mechanism(s), the API shape (REST/GraphQL/gRPC/WebSocket),
and the specific signals that matter (forms, sinks, tokens, dependencies) — each one feeding a
row in the table below.

## Step 5 — Signal → skill routing table

Match what Step 3 found to candidate skills. This list should stay in sync with
[skills/README.md](../README.md); if a new category skill is added there, add its trigger here.

| Signal observed | Candidate skill(s) |
|---|---|
| Any target at all (baseline) | `recon`, `disclosure` |
| JS bundles present | `javascript-recon` |
| Broad/old target, historical paths worth mining | `archive-mining` |
| `.git`, `.env`, backups, keys, tokens exposed | `secret-discovery` |
| Login, registration, password reset, MFA | `auth` |
| JWT in cookie/header/localStorage | `jwt` |
| OAuth/SSO login (`redirect_uri`, `client_id`, `state`) | `oauth` |
| Sequential/UUID IDs referencing user-owned resources | `idor` |
| Business logic flows (pricing, coupons, multi-step workflows) | `logic` |
| REST/JSON API, versioned paths | `api` |
| GraphQL endpoint / introspection enabled | `graphql` |
| gRPC service / `.proto` files | `grpc` |
| Raw protobuf payloads | `proto` |
| WebSocket upgrade (`ws://`, `wss://`) | `websocket` |
| File upload form or endpoint | `upload` |
| Server-side template rendering of user input | `ssti` |
| Raw HTML reflection, no script context | `html-injection` |
| Script-context reflection of user input | `xss` |
| Raw SQL concatenation / ORM misuse | `sqli` |
| NoSQL (Mongo-style) query built from user input | `nosql` |
| LDAP query built from user input | `ldap` |
| OS command execution from user input | `cmdi` |
| Deserialization of untrusted objects | `deserialization` |
| Server-side request driven by user-supplied URL | `ssrf` |
| XML parsing of user input | `xxe` |
| State-changing action with weak/missing CSRF protection | `csrf` |
| No clickjacking protection on sensitive pages | `clickjacking` |
| CORS reflecting `Origin` / wildcard with credentials | `cors` |
| Proxy chain, ambiguous `Content-Length`/`Transfer-Encoding` | `http-smuggling` |
| Cache headers/keys ignoring auth state | `cache` |
| Missing/misconfigured security headers generally | `headers` |
| Open-redirect-shaped params (`next=`, `redirect_uri=`, `url=`) | `redirect` |
| Concurrent state-changing operations (payments, inventory, vouchers) | `race` |
| No rate limiting on expensive or auth endpoints | `dos` |
| Weak/custom crypto, predictable tokens | `crypto` |
| Cloud SDK usage, buckets, IAM, metadata endpoint access | `cloud` |
| CNAME pointing at an unclaimed third-party service | `takeover` |
| Dependency manifests, CI/CD pipelines, build config | `supply` |
| File-serving endpoints with user-controlled path segments | `path` |
| WAF/challenge pages observed on probes | `waf-bypass` |
| Mobile app (APK/IPA) in scope | `mobile` |
| Chatbot, RAG, agent, or prompt-construction code | `llm` |

A single target usually lights up 4–8 rows — that's the expected output, not a sign to run
everything.

## Step 6 — Propose and confirm

Present the ranked candidates (most-signal-backed first) and ask the user to confirm, trim, or
add to the list rather than silently proceeding. Offer a sensible default grouping (e.g. "auth +
idor + jwt" when an authenticated API with object IDs was found) and let the user say "all of
these," "just X," or name something else entirely.

## Step 7 — Load and run the chosen skills

For each confirmed category skill, load it with the `Skill` tool before testing with it — do not
paraphrase its contents from memory. Run them in the order that makes sense (passive/discovery
skills before anything active; skills that build on each other's findings, like `auth` before
`idor`, in that order). Every skill still follows its own link to `testing-rules` for scope,
workflow, and finding format — this orchestrator doesn't relax that.

## Step 8 — Consolidated report

Once the chosen skills have run, merge their findings into one report instead of one per skill,
grouped by severity, using the finding format from `testing-rules`. Note which candidate skills
from Step 5 were *not* run and why (out of scope, user declined, no real signal beyond a weak
guess) so the user can revisit them later.

## Example prompts

```text
Use the hunter skill on https://staging.example.com. This is authorized testing against our
own staging environment with test account creds I'll provide. Map the attack surface first and
tell me what's worth hunting before you test anything.
```

```text
Use the hunter skill on this repo (path: ./app). Map the attack surface from the source and
suggest which category skills apply before running any of them.
```

```text
Use the hunter skill. Here's the staging URL and the backend source for the API it talks to —
map both and tell me where they disagree.
```
