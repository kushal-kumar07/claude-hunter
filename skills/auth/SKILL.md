---
name: claude-auth-security-skill
description: Assess authentication flows, account identity handling, credential controls, and brute-force resistance.
---

# AUTH security assessment

Assess authentication flows, account identity handling, credential controls, and brute-force resistance.

## Shared rules

Follow the authorization rules, assessment workflow, and finding format in [testing-rules](../testing-rules/SKILL.md). Load that skill before testing; do not proceed without confirmed authorization and scope.

## Category-specific focus

Use the prompts below to guide a focused **AUTH** review. Translate each hypothesis into a safe, authorized test and preserve the evidence needed to reproduce or remediate it.

## Confirmed vs. false positive

- **Confirmed when:** An identity or privilege boundary is crossed without the credentials/role that boundary requires (a token or session from one account/role grants another's data or action), reproduced twice.
- **False positive when:** The bypass needs a precondition outside the authorization scope (local admin access, already-compromised credentials), or the server still enforces the check server-side despite a misleading client-side artifact.

## Prompt catalog

### 71. Username enumeration

- **Difficulty:** EASY
- **Slug:** `username-enumeration`
- **Source prompt:** Compare responses, timings, and error messages for valid vs invalid usernames on login, signup, password reset.

### 72. Brute force rate limit test

- **Difficulty:** EASY
- **Slug:** `brute-force-rate-limit-test`
- **Source prompt:** Submit 100 wrong passwords for one user, then 100 different usernames with one password. Report which (if any) is rate-limited.
- **Steps:**
  1. Submit 100 wrong passwords for one user, then 100 different usernames with one password.
  2. Report which (if any) is rate-limited.

### 73. Password reset token reuse

- **Difficulty:** EASY
- **Slug:** `password-reset-token-reuse`
- **Source prompt:** Reset password, copy the reset link, complete the reset, then try the same link again. Report if reusable.
- **Steps:**
  1. Reset password, copy the reset link, complete the reset, then try the same link again.
  2. Report if reusable.

### 74. Password reset token entropy

- **Difficulty:** MED
- **Slug:** `password-reset-token-entropy`
- **Source prompt:** Collect 20 reset tokens for one account. Check length, charset, and predictability. Report low-entropy patterns.
- **Steps:**
  1. Collect 20 reset tokens for one account.
  2. Check length, charset, and predictability.
  3. Report low-entropy patterns.

### 75. Password reset via Host header poison

- **Difficulty:** HARD
- **Slug:** `password-reset-via-host-header-poison`
- **Source prompt:** Send password reset with `Host: attacker.com` or `X-Forwarded-Host: attacker.com`. Check if the reset link points at the attacker host.
- **Steps:**
  1. Send password reset with `Host: attacker.com` or `X-Forwarded-Host: attacker.com`.
  2. Check if the reset link points at the attacker host.

### 76. MFA bypass via response tampering

- **Difficulty:** HARD
- **Slug:** `mfa-bypass-via-response-tampering`
- **Source prompt:** On MFA challenge, intercept the response and change `success:false` to `success:true`, or replay a previous success response.

### 77. MFA bypass by skipping step

- **Difficulty:** HARD
- **Slug:** `mfa-bypass-by-skipping-step`
- **Source prompt:** After password submit, try navigating directly to post-MFA endpoints. Test if the session is fully authenticated before MFA.
- **Steps:**
  1. After password submit, try navigating directly to post-MFA endpoints.
  2. Test if the session is fully authenticated before MFA.

### 78. Session fixation

- **Difficulty:** MED
- **Slug:** `session-fixation`
- **Source prompt:** Set a session cookie before login, log in, and check if the same cookie is still valid.

### 79. Session not invalidated on logout

- **Difficulty:** EASY
- **Slug:** `session-not-invalidated-on-logout`
- **Source prompt:** Capture a session token, log out, replay the token. Report if still accepted.
- **Steps:**
  1. Capture a session token, log out, replay the token.
  2. Report if still accepted.

### 80. Session not invalidated on password change

- **Difficulty:** MED
- **Slug:** `session-not-invalidated-on-password-change`
- **Source prompt:** Log in from two devices. Change password from one. Check if the other session is still valid.
- **Steps:**
  1. Log in from two devices.
  2. Change password from one.
  3. Check if the other session is still valid.

### 81. Remember-me token entropy

- **Difficulty:** MED
- **Slug:** `remember-me-token-entropy`
- **Source prompt:** Decode remember-me cookies (often base64). Check for predictable structure or weak HMAC.
- **Steps:**
  1. Decode remember-me cookies (often base64).
  2. Check for predictable structure or weak HMAC.

### 82. OAuth account takeover via email

- **Difficulty:** HARD
- **Slug:** `oauth-account-takeover-via-email`
- **Source prompt:** Sign up with `victim@example.com` via OAuth provider that does not verify email. Test if you receive access to a pre-existing account with that email.
- **Steps:**
  1. Sign up with `victim@example.com` via OAuth provider that does not verify email.
  2. Test if you receive access to a pre-existing account with that email.

### 83. Password policy weakness

- **Difficulty:** EASY
- **Slug:** `password-policy-weakness`
- **Source prompt:** Try `password`, `12345678`, empty, very long (10kb) passwords. Report if accepted and which length triggers errors.
- **Steps:**
  1. Try `password`, `12345678`, empty, very long (10kb) passwords.
  2. Report if accepted and which length triggers errors.

### 84. Account lockout via username injection

- **Difficulty:** EASY
- **Slug:** `account-lockout-via-username-injection`
- **Source prompt:** Try logging in as `victim@example.com` 100 times to trigger lockout. Report if lockout is exploitable for DoS.
- **Steps:**
  1. Try logging in as `victim@example.com` 100 times to trigger lockout.
  2. Report if lockout is exploitable for DoS.

### 85. JWT `none` algorithm bypass

- **Difficulty:** HARD
- **Slug:** `jwt-none-algorithm-bypass`
- **Source prompt:** Capture a JWT, change `alg` to `none`, strip signature, replay. Also test `HS256` with the public key as secret.
- **Steps:**
  1. Capture a JWT, change `alg` to `none`, strip signature, replay.
  2. Also test `HS256` with the public key as secret.

### 301. Login with email casing / unicode

- **Difficulty:** HARD
- **Slug:** `login-with-email-casing-unicode`
- **Source prompt:** Sign up as `Victim@x.com`, then test `victim@x.com`, `VICTIM@X.COM`, `victìm@x.com`, NFKC variants. Report duplicate-account or takeover.
- **Steps:**
  1. Sign up as `Victim@x.com`, then test `victim@x.com`, `VICTIM@X.COM`, `victìm@x.com`, NFKC variants.
  2. Report duplicate-account or takeover.

### 302. OTP brute force

- **Difficulty:** MED
- **Slug:** `otp-brute-force`
- **Source prompt:** Submit all 1M codes for a 6-digit OTP. Report if no rate limit or lock.
- **Steps:**
  1. Submit all 1M codes for a 6-digit OTP.
  2. Report if no rate limit or lock.

## Additional web checks

### Session lifecycle

With two owned test accounts, verify that login rotates the pre-authentication session, logout
invalidates the old token, and password/email changes revoke prior sessions. Review refresh-token
rotation and reuse detection, cookie `Secure`/`HttpOnly`/`SameSite` attributes, `__Host-` usage,
session entropy, and tokens placed in URLs. Missing `HttpOnly` is strongest when a real XSS sink
exists; do not report the flag in isolation.

### Password recovery

Compare valid and invalid recovery responses and timing, inspect whether reset tokens appear in
API responses or referrers, and test single-use, expiry, binding, and rate limits using only an
owned account. A recovery weakness becomes account takeover only when the full chain is proven.

### MFA and recovery bypass

Check direct navigation to post-MFA routes, alternate API methods, remembered-device paths,
backup-code reuse, recovery-factor replacement, and whether sensitive changes require a fresh
challenge. Stop at a harmless test-account state change.
