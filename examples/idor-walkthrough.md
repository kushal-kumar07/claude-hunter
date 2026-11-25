# End-to-end example: IDOR skill against a staging order-history endpoint

This walks through one full pass of the [IDOR skill](../skills/idor/SKILL.md) end to end: scope,
prompt, test, evidence, and the finding report it produces. It's a worked example for
authorized, two-account testing against a local/staging fixture — not a case study of a real
target.

## 1. Set the scope

```text
This is an authorized test of a staging instance of our order-history feature
(orders.staging.internal). I have two test accounts: user-a and user-b, each
with one synthetic order. Use the IDOR skill. Start passively, stay under
5 requests/second, and stop before any destructive action. Report confirmed
findings with sanitized evidence, impact, and remediation.
```

## 2. Pick a hypothesis from the prompt catalog

The skill's prompt catalog entry **"Sequential ID enumeration"** (`skills/idor/SKILL.md`) fits:

> Identify every endpoint with numeric IDs (`/users/123`, `/orders/456`). Authenticate as user A,
> then access user B's IDs (±1, ±10, ±100). Report any 200 responses.

Its **Steps** breakdown turns that into a checklist:

1. Identify every endpoint with numeric IDs.
2. Authenticate as user A, then access user B's IDs (±1, ±10, ±100).
3. Report any 200 responses.

## 3. Run the test

- Logged in as `user-a`, the order-history page requests `GET /api/orders/1001`, which returns
  `user-a`'s own synthetic order.
- `user-b`'s synthetic order was created immediately after and is known (from account setup) to
  be `/api/orders/1002`.
- Staying authenticated as `user-a`, request `GET /api/orders/1002` directly.

## 4. Capture evidence

```http
GET /api/orders/1002 HTTP/1.1
Host: orders.staging.internal
Cookie: session=<user-a-session>
```

```http
HTTP/1.1 200 OK
Content-Type: application/json

{"order_id": 1002, "owner": "user-b", "items": [...], "shipping_address": "..."}
```

Repeated twice, with the same result both times: `user-a`'s session reads `user-b`'s full order,
with no ownership check on the server.

## 5. Apply the confirmed-vs-false-positive test

From the skill's **Confirmed vs. false positive** section:

- **Confirmed when:** a request made with one principal's session reads or modifies another
  principal's resource by changing only an identifier, with no ownership/role check on the
  server. — This is exactly what happened: only the path identifier changed, and the response
  held `user-b`'s real (synthetic) data.
- **False positive when:** the identifier is only reachable by brute-forcing an out-of-scope
  keyspace, or the server returns a generic/empty response. — Neither applies: the ID was
  adjacent and known, and the response held real order data, not an empty or generic one.

This is a confirmed finding, not a false positive.

## 6. Write the report

Using the shared [finding format](../skills/testing-rules/SKILL.md):

---

**Title:** Broken object-level authorization on `GET /api/orders/{id}`
**Severity:** High
**Confidence:** Confirmed (reproduced twice)

**Affected asset and authorization context:** `orders.staging.internal`, authorized two-account
test (`user-a`, `user-b`), staging environment.

**Preconditions and reproduction steps:**
1. Authenticate as `user-a`.
2. Note `user-a`'s own order ID returned by the order-history page (`1001`).
3. Request `GET /api/orders/1002` using `user-a`'s session.
4. Observe `user-b`'s order data in the response.

**Sanitized evidence:** request/response pair above; two independent runs, same result.

**Security impact and affected users/data:** any authenticated user can read any other user's
order, including shipping address, by incrementing the order ID. No brute-forcing or guessing
required — IDs are sequential and the keyspace is small.

**Root cause:** `/api/orders/{id}` loads the order by ID without checking that the order belongs
to the requesting session's account.

**Recommended remediation and regression test:** add an ownership check (`order.owner_id ==
session.user_id`) before returning order data, return 403/404 for mismatches, and add a
regression test asserting that `user-a`'s session cannot read `user-b`'s order by ID.

---

## Notes on adapting this

- Swap in whatever two-account setup and resource type match your target (orders, documents,
  tickets, messages). The shape of the test — same session, only the identifier changes — carries
  over directly.
- If the server instead returns a generic error or empty body for `/api/orders/1002`, that's the
  false-positive case from step 5: stop there, it isn't a finding.
