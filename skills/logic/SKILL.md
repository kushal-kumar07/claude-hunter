---
name: claude-logic-security-skill
description: Assess business rules, workflow transitions, and invariant enforcement for abuse-resistant behavior.
---

# LOGIC security assessment

Assess business rules, workflow transitions, and invariant enforcement for abuse-resistant behavior.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **LOGIC** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** Performing steps out of order, repeating a step, or combining features causes an unintended state change (double-use, balance mismatch, unintended discount), reproduced deterministically.
- **False positive when:** The anomaly is a UI-only glitch with no backend state effect, or the behavior is a known, intended feature.

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
- **Steps:**
  1. Apply multiple coupons in sequence; test if non-stackable coupons combine.
  2. Apply same coupon twice.

### 149. Free trial reset

- **Difficulty:** EASY
- **Slug:** `free-trial-reset`
- **Source prompt:** Cancel trial, re-signup with same email/payment, with email aliases (`user+1@`), with capitalization changes.

### 150. Skipping required steps

- **Difficulty:** MED
- **Slug:** `skipping-required-steps`
- **Source prompt:** In multi-step wizards (checkout, KYC, onboarding), jump directly to the final POST. Test if intermediate validation is enforced server-side.
- **Steps:**
  1. In multi-step wizards (checkout, KYC, onboarding), jump directly to the final POST.
  2. Test if intermediate validation is enforced server-side.

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
- **Steps:**
  1. Buy premium → use feature → downgrade.
  2. Test if feature access lingers.

### 156. Trial extension via timezone

- **Difficulty:** EASY
- **Slug:** `trial-extension-via-timezone`
- **Source prompt:** Set local timezone to manipulate expiry windows. Test client-side time checks.
- **Steps:**
  1. Set local timezone to manipulate expiry windows.
  2. Test client-side time checks.

### 157. Workflow state regression

- **Difficulty:** MED
- **Slug:** `workflow-state-regression`
- **Source prompt:** On state-machine objects (order, ticket), POST transitions in invalid sequence (e.g., `delivered → pending`).

## Additional coverage

- Workflow state-machine violations and step skipping.
- Price, quantity, currency, coupon, refund, referral, subscription, and entitlement manipulation.
- Multi-account abuse and race-assisted business logic flaws.
- Validate invariants using owned test accounts, synthetic orders, and reversible actions.
