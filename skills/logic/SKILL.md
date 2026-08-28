---
name: claude-logic-security-skill
description: Assess business rules, workflow transitions, and invariant enforcement for abuse-resistant behavior.
---

# LOGIC security assessment

Assess business rules, workflow transitions, and invariant enforcement for abuse-resistant behavior.

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

Use the prompts below to guide a focused **LOGIC** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Prompt catalog

### 146. Negative quantity / price

- **Difficulty:** EASY
- **Slug:** `negative-quantity-price`
- **Source prompt:** Submit negative quantities, negative prices, and very large numbers (`Number.MAX_SAFE_INTEGER`, `1e308`) in cart/order endpoints.

### 147. Integer overflow in price

- **Difficulty:** MED
- **Slug:** `integer-overflow-in-price`
- **Source prompt:** Submit quantities like `2147483648` to cause int overflow.

### 148. Coupon stacking

- **Difficulty:** MED
- **Slug:** `coupon-stacking`
- **Source prompt:** Apply multiple coupons in sequence; test if non-stackable coupons combine. Apply same coupon twice.

### 149. Free trial reset

- **Difficulty:** EASY
- **Slug:** `free-trial-reset`
- **Source prompt:** Cancel trial, re-signup with same email/payment, with email aliases (`user+1@`), with capitalization changes.

### 150. Skipping required steps

- **Difficulty:** MED
- **Slug:** `skipping-required-steps`
- **Source prompt:** In multi-step wizards (checkout, KYC, onboarding), jump directly to the final POST. Test if intermediate validation is enforced server-side.

### 151. Currency manipulation

- **Difficulty:** MED
- **Slug:** `currency-manipulation`
- **Source prompt:** Submit prices in cheaper currencies; mismatch currency between cart and checkout.

### 152. Refund > purchase

- **Difficulty:** HARD
- **Slug:** `refund-purchase`
- **Source prompt:** Issue refund larger than the original charge.

### 153. Cart manipulation post-pricing

- **Difficulty:** MED
- **Slug:** `cart-manipulation-post-pricing`
- **Source prompt:** Add item, get price, then swap product ID at checkout while keeping old price.

### 154. Bypass paywall via cache

- **Difficulty:** HARD
- **Slug:** `bypass-paywall-via-cache`
- **Source prompt:** Trigger article fetch as a paying user, then access via cache/CDN with no auth.

### 155. Privilege via plan downgrade

- **Difficulty:** MED
- **Slug:** `privilege-via-plan-downgrade`
- **Source prompt:** Buy premium → use feature → downgrade. Test if feature access lingers.

### 156. Trial extension via timezone

- **Difficulty:** EASY
- **Slug:** `trial-extension-via-timezone`
- **Source prompt:** Set local timezone to manipulate expiry windows. Test client-side time checks.

### 157. Workflow state regression

- **Difficulty:** MED
- **Slug:** `workflow-state-regression`
- **Source prompt:** On state-machine objects (order, ticket), POST transitions in invalid sequence (e.g., `delivered → pending`).

## Source attribution

- Source: [https://hackwithclaude.com/prompts](https://hackwithclaude.com/prompts)
- Retrieved: 2026-08-28
- Included prompts: 12

## Additional coverage

- Workflow state-machine violations and step skipping.
- Price, quantity, currency, coupon, refund, referral, subscription, and entitlement manipulation.
- Multi-account abuse and race-assisted business logic flaws.
- Validate invariants using owned test accounts, synthetic orders, and reversible actions.

### Source attribution

- Adapted from `SnailSploit/Claude-Red` `Skills/web/offensive-business-logic/SKILL.md`.
- Source repository: https://github.com/SnailSploit/Claude-Red
