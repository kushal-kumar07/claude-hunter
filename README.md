```text
   _____ _                 _        _                 _
  / ____| |               | |      | |               | |
 | |    | | __ _ _   _  __| | ___  | |__  _   _ _ __ | |_ ___ _ __
 | |    | |/ _` | | | |/ _` |/ _ \ | '_ \| | | | '_ \| __/ _ \ '__|
 | |____| | (_| | |_| | (_| |  __/ | | | | |_| | | | | ||  __/ |
  \_____|_|\__,_|\__,_|\__,_|\___| |_| |_|\__,_|_| |_|\__\___|_|

                         C L A U D E - H U N T E R
```

# Claude web security skills

Simple, reusable security-review skills for Claude. The bundle contains a broad collection of
web-focused security skills and curated prompt sets covering common vulnerabilities, API issues,
misconfigurations, and recon workflows. Each skill includes a description, a list of prompts,
and guidance for safe and authorized testing.

## New: the HUNTER orchestrator skill

Don't know which of the 40+ category skills below applies to your target? Use
[HUNTER](skills/hunter/SKILL.md) instead of picking one by hand.

Give it a URL, source code, or both, and it:

1. Confirms scope and authorization (via `testing-rules`) before touching a live target.
2. Maps the attack surface — live recon for a URL, static analysis for source code, or both,
   correlated against each other.
3. Summarizes what it found and matches each signal (JWTs, upload forms, GraphQL, raw SQL,
   outbound requests, etc.) against the right category skill(s) using a built-in routing table.
4. Proposes a ranked shortlist and confirms with you — it never silently decides what to test.
5. Loads the confirmed skills and runs them, then merges their findings into one report.

```text
Use the hunter skill on https://staging.example.com. This is authorized testing against our
own staging environment. Map the attack surface first and tell me what's worth hunting before
you test anything.
```

```text
Use the hunter skill on this repo (path: ./app). Map the attack surface from the source and
suggest which category skills apply before running any of them.
```

## Authorized and educational use only

These skills are provided only for authorized security testing, education, and learning. Use them
only on systems, applications, accounts, and repositories that you own or have explicit written
permission to test. You are solely responsible for complying with all applicable laws, contracts,
program rules, and scope limitations.

The authors and contributors are **not responsible for any misuse, damage, loss, unauthorized
access, disruption, or other consequences** resulting from the use or inability to use these
materials. Do not use them against third-party systems without permission.

## Install in Claude Code

### Option 1: Use in one project (recommended)

From the root of your project, copy this folder into `.claude/skills/`:

```bash
mkdir -p .claude/skills
cp -R /Users/kushal/Downloads/claude-hunter/skills/* .claude/skills/
```

Your project should look like this:

```text
your-project/
└── .claude/
    └── skills/
        ├── xss/SKILL.md
        ├── sqli/SKILL.md
        ├── ssrf/SKILL.md
        └── ...
```

### Option 2: Use across projects

Copy the skill folders into the Claude Code personal skills directory:

```bash
mkdir -p ~/.claude/skills
cp -R /Users/kushal/Downloads/claude-hunter/skills/* ~/.claude/skills/
```

Restart Claude Code after installing if the skills do not appear immediately.

## Install or remove with the setup script

From the project root, make the helper executable once:

```bash
chmod +x ./setup.sh
```

Install all skills for Claude Code:

```bash
./setup.sh --install claude
```

Install all skills for Codex:

```bash
./setup.sh --install codex
```

Remove the skills installed by this project:

```bash
./setup.sh --remove claude
./setup.sh --remove codex
```

The script copies skills into `~/.claude/skills/` or `~/.codex/skills/`. It refuses to overwrite
existing skills and records its own folders in a managed manifest. Removal deletes only the skills
listed in that manifest, so other skills are left untouched. Restart Claude Code or Codex after
installation if the skills are not detected immediately.

## Use a skill

You do not need to paste the whole `SKILL.md` file into chat. Tell Claude what you want and
mention the skill name:

```text
Use the XSS skill. Review this authorized staging application for reflected,
stored, and DOM XSS. Use safe canaries and give me reproducible findings.
```

## JavaScript and secret discovery tools

When you use the recon and disclosure workflows, the following tools are especially useful:

- `gau` and `waybackurls` for historical URL mining
- `linkfinder` and `hakrawler` for JavaScript endpoint extraction
- `httpx` and `curl` for live validation
- `trufflehog`, `gitleaks`, and `secretfinder` for secret discovery
- `ffuf` for path and endpoint fuzzing after discovery

Example install on macOS with Homebrew and Go:

```bash
brew install ffuf

go install -v github.com/tomnomnom/waybackurls@latest
go install -v github.com/lc/gau/v2/cmd/gau@latest
go install -v github.com/hakluke/hakrawler@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/hahwul/dalfox/v2@latest

python3 -m pip install dirsearch wfuzz
```

Make sure your Go bin directory is on PATH:

```bash
export PATH="$(go env GOPATH)/bin:$PATH"
```

## Wordlists

The [wordlists/](wordlists/) folder contains curated lists for authorized web testing:

- Directory and content discovery
- API route and action discovery
- Query/body parameter enumeration
- Files, backups, and extensions
- Framework/server paths
- Proxy and trust-boundary headers
- Safe test canaries

Start with the small lists, then use the medium RAFT list only when the target and rate limits
allow it. Example:

```bash
ffuf -u https://target.example/FUZZ \
  -w wordlists/content-discovery/raft-small-words.txt \
  -mc 200,204,301,302,307,401,403
```

Use only an authorized target, keep concurrency conservative, and review every result manually.

More examples:

```text
Use the SSRF skill to review the webhook feature in my local test app.
```

```text
Use the API and IDOR skills to check these two test accounts for
cross-user access. Do not enumerate real data.
```

```text
Use the WAF bypass skill to compare blocked and allowed requests in my
authorized lab. Stop after a harmless canary reaches the origin.
```

Claude can also combine skills:

```text
Use RECON, API, DISCLOSURE, and IDOR skills to review this authorized
staging target. Start with passive discovery and report each step.
```

## Choosing the right skill

| What you are testing | Start with |
|---|---|
| Browser script injection | [XSS](skills/xss/SKILL.md) |
| Database query injection | [SQLI](skills/sqli/SKILL.md) |
| Server-side URL fetching | [SSRF](skills/ssrf/SKILL.md) |
| Cross-user object access | [IDOR](skills/idor/SKILL.md) |
| Login, sessions, reset, or MFA | [AUTH](skills/auth/SKILL.md) |
| Cross-site forged actions | [CSRF](skills/csrf/SKILL.md) |
| File handling | [UPLOAD](skills/upload/SKILL.md) |
| Template expression injection | [SSTI](skills/ssti/SKILL.md) |
| Redirect destinations | [REDIRECT](skills/redirect/SKILL.md) |
| API parsing and authorization | [API](skills/api/SKILL.md) |
| HTTP proxy desynchronization | [HTTP smuggling](skills/http-smuggling/SKILL.md) |
| Framing sensitive pages | [Clickjacking](skills/clickjacking/SKILL.md) |
| Raw HTML without scripts | [HTML injection](skills/html-injection/SKILL.md) |
| gRPC services | [gRPC](skills/grpc/SKILL.md) |
| Firewall/parser differences | [WAF bypass](skills/waf-bypass/SKILL.md) |
| Exposed files, source maps, or schemas | [DISCLOSURE](skills/disclosure/SKILL.md) |
| Forgotten API versions | [API](skills/api/SKILL.md) |

If you are unsure, start with [HUNTER](skills/hunter/SKILL.md) to map the attack surface and get a
routed shortlist, or manually with [RECON](skills/recon/SKILL.md), [DISCLOSURE](skills/disclosure/SKILL.md),
and [API](skills/api/SKILL.md), then move to the specific vulnerability skill.

## A simple workflow

1. Tell Claude the target, scope, test account, and environment.
2. Name one or more skills.
3. Ask Claude to begin with passive discovery and safe canaries.
4. Review each finding before any active or state-changing test.
5. Ask for a report containing reproduction steps, evidence, impact, and remediation.

Use this starter prompt:

```text
This is an authorized test of <target> in <staging/local environment>.
Use the <skill-name> skill. Use only my test account and synthetic data.
Start passively, stay within <rate/concurrency limits>, and stop before
destructive actions. Report confirmed findings with sanitized evidence,
impact, and remediation.
```

## Safety rules

- Only test systems, accounts, and repositories covered by written authorization.
- Prefer local fixtures, staging, synthetic records, and non-destructive canaries.
- Do not access, alter, exfiltrate, or persist real user data.
- Set rate, concurrency, payload-size, and stop limits before testing.
- Stop if availability, confidentiality, or integrity may be affected.
- Redact credentials, tokens, personal data, and private URLs from reports.

## Included skills

- [HUNTER (attack-surface mapping + skill routing)](skills/hunter/SKILL.md)
- [XSS (25 prompts)](skills/xss/SKILL.md)
- [SQLI (15 prompts)](skills/sqli/SKILL.md)
- [SSRF (15 prompts)](skills/ssrf/SKILL.md)
- [IDOR (15 prompts)](skills/idor/SKILL.md)
- [AUTH (17 prompts)](skills/auth/SKILL.md)
- [CSRF (10 prompts)](skills/csrf/SKILL.md)
- [UPLOAD (12 prompts)](skills/upload/SKILL.md)
- [RCE (10 prompts)](skills/rce/SKILL.md)
- [XXE (6 prompts)](skills/xxe/SKILL.md)
- [SSTI (8 prompts)](skills/ssti/SKILL.md)
- [REDIRECT (6 prompts)](skills/redirect/SKILL.md)
- [RACE (8 prompts)](skills/race/SKILL.md)
- [LOGIC (12 prompts)](skills/logic/SKILL.md)
- [API (12 prompts)](skills/api/SKILL.md)
- [JWT (8 prompts)](skills/jwt/SKILL.md)
- [CORS (6 prompts)](skills/cors/SKILL.md)
- [PATH (6 prompts)](skills/path/SKILL.md)
- [DESERIALIZATION (5 prompts)](skills/deserialization/SKILL.md)
- [TAKEOVER (5 prompts)](skills/takeover/SKILL.md)
- [GRAPHQL (6 prompts)](skills/graphql/SKILL.md)
- [MOBILE (6 prompts)](skills/mobile/SKILL.md)
- [CLOUD (8 prompts)](skills/cloud/SKILL.md)
- [CRYPTO (6 prompts)](skills/crypto/SKILL.md)
- [OAUTH (8 prompts)](skills/oauth/SKILL.md)
- [HEADERS (6 prompts)](skills/headers/SKILL.md)
- [CACHE (6 prompts)](skills/cache/SKILL.md)
- [WEBSOCKET (4 prompts)](skills/websocket/SKILL.md)
- [PROTO (4 prompts)](skills/proto/SKILL.md)
- [NOSQL (3 prompts)](skills/nosql/SKILL.md)
- [LDAP (3 prompts)](skills/ldap/SKILL.md)
- [CMDI (3 prompts)](skills/cmdi/SKILL.md)
- [DISCLOSURE (10 prompts)](skills/disclosure/SKILL.md)
- [RECON (8 prompts)](skills/recon/SKILL.md)
- [JavaScript recon](skills/javascript-recon/SKILL.md)
- [Archive mining](skills/archive-mining/SKILL.md)
- [Secret discovery](skills/secret-discovery/SKILL.md)
- [Tooling guide](skills/tooling/SKILL.md)
- [LLM (14 prompts)](skills/llm/SKILL.md)
- [SUPPLY (4 prompts)](skills/supply/SKILL.md)
- [DOS (6 prompts)](skills/dos/SKILL.md)
- [HTTP request smuggling](skills/http-smuggling/SKILL.md)
- [Clickjacking](skills/clickjacking/SKILL.md)
- [HTML injection](skills/html-injection/SKILL.md)
- [gRPC](skills/grpc/SKILL.md)
- [WAF bypass](skills/waf-bypass/SKILL.md)

## Example

[examples/idor-walkthrough.md](examples/idor-walkthrough.md) walks through one full pass of a
skill end to end: scope, prompt, test, evidence, and the finding report it produces.

## license

Released under the [MIT License](LICENSE).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to add or improve a skill.
