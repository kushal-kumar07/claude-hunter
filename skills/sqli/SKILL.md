---
name: claude-sqli-security-skill
description: Assess SQL query construction for injection, authentication bypass, and data-access boundary failures.
---

# SQLI security assessment

Assess SQL query construction for injection, authentication bypass, and data-access boundary failures.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **SQLI** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** A deterministic behavioral difference (content, boolean, timing, or extracted data) ties directly to the injected syntax and reproduces across repeated requests, with a DB error, banner/version, or out-of-scope data as evidence.
- **False positive when:** A timing difference within normal network/server jitter, a single non-reproducible anomaly, or an error caused by basic input validation unrelated to query structure.

## Prompt catalog

### 26. Error-based SQLi probe

- **Difficulty:** EASY
- **Slug:** `error-based-sqli-probe`
- **Source prompt:** For each parameter (GET, POST, JSON body, headers), append `'`, `"`, `\`, `')`, `'))`. Diff responses. Report parameters that emit SQL errors or 500s differing from baseline.
- **Steps:**
  1. For each parameter (GET, POST, JSON body, headers), append `'`, `"`, `\`, `')`, `'))`.
  2. Diff responses.
  3. Report parameters that emit SQL errors or 500s differing from baseline.

### 27. Boolean-based blind SQLi

- **Difficulty:** MED
- **Slug:** `boolean-based-blind-sqli`
- **Source prompt:** Pick a parameter that affects response content. Send `' AND 1=1-- -` and `' AND 1=2-- -`. If responses differ deterministically, confirm blind SQLi and extract DB version.
- **Steps:**
  1. Pick a parameter that affects response content.
  2. Send `' AND 1=1-- -` and `' AND 1=2-- -`.
  3. If responses differ deterministically, confirm blind SQLi and extract DB version.

### 28. Time-based blind SQLi

- **Difficulty:** MED
- **Slug:** `time-based-blind-sqli`
- **Source prompt:** Send `' AND SLEEP(5)-- -` (MySQL), `'; WAITFOR DELAY '0:0:5'-- ` (MSSQL), `' AND pg_sleep(5)-- -` (Postgres). Compare response times. Report time-delta vulnerabilities.
- **Steps:**
  1. Send `' AND SLEEP(5)-- -` (MySQL), `'; WAITFOR DELAY '0:0:5'-- ` (MSSQL), `' AND pg_sleep(5)-- -` (Postgres).
  2. Compare response times.
  3. Report time-delta vulnerabilities.

### 29. UNION-based SQLi column count

- **Difficulty:** MED
- **Slug:** `union-based-sqli-column-count`
- **Source prompt:** Use `ORDER BY 1--`, `ORDER BY 2--`, ... until error, then `UNION SELECT NULL,NULL,...` to identify column count and reflected column.
- **Steps:**
  1. Use `ORDER BY 1--`, `ORDER BY 2--`, ...
  2. until error, then `UNION SELECT NULL,NULL,...` to identify column count and reflected column.

### 30. Second-order SQLi

- **Difficulty:** HARD
- **Slug:** `second-order-sqli`
- **Source prompt:** Inject `' || (SELECT version())-- ` into fields that are stored then later used in queries (username, file path, log message). Trigger the second query and observe.
- **Steps:**
  1. Inject `' || (SELECT version())-- ` into fields that are stored then later used in queries (username, file path, log message).
  2. Trigger the second query and observe.

### 31. SQLi via ORDER BY / column names

- **Difficulty:** MED
- **Slug:** `sqli-via-order-by-column-names`
- **Source prompt:** Test injection in sort parameters (`?sort=name`). Try `name,(CASE WHEN 1=1 THEN 1 ELSE 2 END)`.
- **Steps:**
  1. Test injection in sort parameters (`?sort=name`).
  2. Try `name,(CASE WHEN 1=1 THEN 1 ELSE 2 END)`.

### 32. NoSQL injection in MongoDB

- **Difficulty:** EASY
- **Slug:** `nosql-injection-in-mongodb`
- **Source prompt:** Send `{"$ne": null}`, `{"$gt": ""}`, `{"$regex": ".*"}` in JSON login fields. Report auth bypass.
- **Steps:**
  1. Send `{"$ne": null}`, `{"$gt": ""}`, `{"$regex": ".*"}` in JSON login fields.
  2. Report auth bypass.

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
- **Steps:**
  1. Test `User-Agent`, `X-Forwarded-For`, `Referer` for SQLi by sending tautologies and time delays.
  2. Common in logging/analytics tables.

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
- **Steps:**
  1. Find places where user input becomes part of an INSERT (signup, comment).
  2. Test `', (SELECT version()))-- -` patterns.

### 40. SQLi via XML body

- **Difficulty:** MED
- **Slug:** `sqli-via-xml-body`
- **Source prompt:** If endpoint accepts XML, inject SQL into XML element values and attributes — these often skip the JSON sanitizer.

## Additional coverage

- Second-order SQL injection through stored values and delayed query execution.
- Out-of-band and JSON/operator injection where explicitly in scope.
- SQL injection through GraphQL, WebSocket, and ORM query layers.
- Database-specific parser differences and WAF canonicalization gaps, validated with harmless
  boolean or timing canaries.
