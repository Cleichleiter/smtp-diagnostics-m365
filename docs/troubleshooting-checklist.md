# SMTP Troubleshooting Checklist for Microsoft 365 and MFP Devices

---

## Purpose

This checklist provides a structured, repeatable approach to diagnosing scan-to-email failures on multifunction printers (MFPs) using Microsoft 365.

Use this to avoid circular troubleshooting and to quickly isolate whether the issue is network, TLS, authentication, or reputation-related.

---

## Step 1: Identify the SMTP Method in Use

Confirm which SMTP method is configured on the device:

* Direct Send (MX endpoint, port 25)
* SMTP Relay (connector + port 25)
* SMTP Submission (smtp.office365.com, port 587)

Document this **before** changing anything.

---

## Step 2: Confirm Basic Network Connectivity

From a device on the same network as the printer:

* DNS resolution of SMTP host
* TCP connectivity to the configured port
* No outbound firewall blocks

Commands to verify:

* `Test-NetConnection <host> -Port <port>`
* Basic ping (non-diagnostic, informational only)

---

## Step 3: Verify SMTP Banner and EHLO

Using a script or tool:

* Confirm SMTP banner is returned
* Confirm EHLO response is received
* Check advertised capabilities:

  * STARTTLS
  * SIZE
  * PIPELINING

If EHLO fails or hangs, suspect firewall inspection or MTU issues.

---

## Step 4: Validate STARTTLS Negotiation

If encryption is enabled:

* Confirm STARTTLS is advertised
* Confirm TLS handshake completes
* Confirm re-EHLO succeeds after TLS

TLS success rules out most MTU and fragmentation issues.

---

## Step 5: Perform Full SMTP Conversation Test

This is the **critical diagnostic step**.

Manually test:

* `MAIL FROM`
* `RCPT TO`

Do not rely on connector validation tests alone.

Failures at this stage often reveal:

* IP reputation blocks
* Recipient rejection
* Policy enforcement

---

## Step 6: Check Microsoft 365 Message Trace

* Look for messages from the device
* Note whether messages appear at all
* Absence of trace entries often indicates pre-acceptance rejection

---

## Step 7: Evaluate IP Reputation (Port 25 Only)

If using Direct Send or SMTP Relay:

* Check public IP reputation
* Be suspicious of residential or dynamic IPs
* Understand that reputation blocks may occur at RCPT TO

Do not assume successful connection equals acceptance.

---

## Step 8: Test SMTP Submission as a Control

Configure temporarily:

* Server: smtp.office365.com
* Port: 587
* STARTTLS
* SMTP AUTH enabled on mailbox

If this works immediately, the issue is almost certainly IP or port 25 related.

---

## Step 9: Review Authentication Settings

For SMTP Submission:

* SMTP AUTH enabled on mailbox
* Correct username format
* Password entered exactly
* MFA disabled or bypassed for SMTP

Authentication failures are usually explicit and repeatable.

---

## Step 10: Document Findings Before Making Changes

Before switching methods permanently:

* Record exact error messages
* Save SMTP transcripts
* Capture final working configuration

This prevents future regression and speeds up similar cases.

---

## Common Pitfalls

* Assuming connector tests validate delivery
* Disabling firewall security prematurely
* Chasing MTU issues after TLS success
* Ignoring RCPT TO stage failures
* Using Direct Send on non-enterprise IPs

---

## Recommended Default

For most environments:

* Use SMTP Submission (587)
* Use dedicated mailboxes
* Avoid port 25 unless absolutely required

---

End of document.

---
