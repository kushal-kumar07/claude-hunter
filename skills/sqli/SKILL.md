---
name: claude-sqli-security-skill
description: Assess SQL query construction for injection, authentication bypass, and data-access boundary failures.
---

# SQLI security assessment

Assess SQL query construction for injection, authentication bypass, and data-access boundary failures.

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

Use the prompts below to guide a focused **SQLI** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Prompt catalog

### 26. Error-based SQLi probe

- **Difficulty:** EASY
- **Slug:** `error-based-sqli-probe`
- **Source prompt:** For each parameter (GET, POST, JSON body, headers), append `'`, `"`, `\`, `')`, `'))`. Diff responses. Report parameters that emit SQL errors or 500s differing from baseline.

### 27. Boolean-based blind SQLi

- **Difficulty:** MED
- **Slug:** `boolean-based-blind-sqli`
- **Source prompt:** Pick a parameter that affects response content. Send `' AND 1=1-- -` and `' AND 1=2-- -`. If responses differ deterministically, confirm blind SQLi and extract DB version.

### 28. Time-based blind SQLi

- **Difficulty:** MED
- **Slug:** `time-based-blind-sqli`
- **Source prompt:** Send `' AND SLEEP(5)-- -` (MySQL), `'; WAITFOR DELAY '0:0:5'-- ` (MSSQL), `' AND pg_sleep(5)-- -` (Postgres). Compare response times. Report time-delta vulnerabilities.

### 29. UNION-based SQLi column count

- **Difficulty:** MED
- **Slug:** `union-based-sqli-column-count`
- **Source prompt:** Use `ORDER BY 1--`, `ORDER BY 2--`, ... until error, then `UNION SELECT NULL,NULL,...` to identify column count and reflected column.

### 30. Second-order SQLi

- **Difficulty:** HARD
- **Slug:** `second-order-sqli`
- **Source prompt:** Inject `' || (SELECT version())-- ` into fields that are stored then later used in queries (username, file path, log message). Trigger the second query and observe.

### 31. SQLi via ORDER BY / column names

- **Difficulty:** MED
- **Slug:** `sqli-via-order-by-column-names`
- **Source prompt:** Test injection in sort parameters (`?sort=name`). Try `name,(CASE WHEN 1=1 THEN 1 ELSE 2 END)`.

### 32. NoSQL injection in MongoDB

- **Difficulty:** EASY
- **Slug:** `nosql-injection-in-mongodb`
- **Source prompt:** Send `{"$ne": null}`, `{"$gt": ""}`, `{"$regex": ".*"}` in JSON login fields. Report auth bypass.

### 33. SQLi via JSON parameters

- **Difficulty:** MED
- **Slug:** `sqli-via-json-parameters`
- **Source prompt:** If the API accepts `{"filter": {"id": 1}}`, replace value with `{"$gt": 0}` (NoSQL) or `"1 OR 1=1"` (SQL passthrough).

### 34. Out-of-band SQLi via DNS

- **Difficulty:** HARD
- **Slug:** `out-of-band-sqli-via-dns`
- **Source prompt:** On MySQL with `LOAD_FILE` or MSSQL with `xp_dirtree`, exfil data through DNS lookups to a Burp Collaborator domain.

### 35. SQLi in stored procedures

- **Difficulty:** HARD
- **Slug:** `sqli-in-stored-procedures`
- **Source prompt:** If parameters feed into stored procs, test `'; EXEC sp_who-- ` (MSSQL) and provider-specific escapes.

### 36. SQLi via header values

- **Difficulty:** MED
- **Slug:** `sqli-via-header-values`
- **Source prompt:** Test `User-Agent`, `X-Forwarded-For`, `Referer` for SQLi by sending tautologies and time delays. Common in logging/analytics tables.

### 37. SQLi in LIMIT / OFFSET

- **Difficulty:** HARD
- **Slug:** `sqli-in-limit-offset`
- **Source prompt:** Inject `1 PROCEDURE ANALYSE()` after LIMIT in MySQL; test `OFFSET (SELECT...)` patterns.

### 38. SQLi via WAF bypass

- **Difficulty:** HARD
- **Slug:** `sqli-via-waf-bypass`
- **Source prompt:** If a WAF blocks `UNION SELECT`, try `/**/UNION/**/SELECT`, `%23%0A`, comments inside keywords, case variation, and Unicode normalization.

### 39. SQLi in INSERT path

- **Difficulty:** HARD
- **Slug:** `sqli-in-insert-path`
- **Source prompt:** Find places where user input becomes part of an INSERT (signup, comment). Test `', (SELECT version()))-- -` patterns.

### 40. SQLi via XML body

- **Difficulty:** MED
- **Slug:** `sqli-via-xml-body`
- **Source prompt:** If endpoint accepts XML, inject SQL into XML element values and attributes — these often skip the JSON sanitizer.

## Source attribution

- Source: [https://hackwithclaude.com/prompts](https://hackwithclaude.com/prompts)
- Retrieved: 2026-08-28
- Included prompts: 15

## Additional coverage

- Second-order SQL injection through stored values and delayed query execution.
- Out-of-band and JSON/operator injection where explicitly in scope.
- SQL injection through GraphQL, WebSocket, and ORM query layers.
- Database-specific parser differences and WAF canonicalization gaps, validated with harmless
  boolean or timing canaries.

### Source attribution

- Adapted from `SnailSploit/Claude-Red` `Skills/web/offensive-sqli/SKILL.md`.
- Source repository: https://github.com/SnailSploit/Claude-Red
