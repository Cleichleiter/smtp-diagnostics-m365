# Validation and Testing Procedures for SMTP on MFP Devices

---

## Purpose

This document defines how to **validate** and **prove** that an SMTP configuration for a multifunction printer (MFP) is working correctly in Microsoft 365, beyond “test succeeded” messages in device UIs.

The goal is to eliminate false positives and confirm real mail acceptance and delivery.

---

## What “Working” Actually Means

An SMTP configuration is only considered **validated** when all of the following are true:

* SMTP connection succeeds
* STARTTLS (if enabled) completes successfully
* MAIL FROM is accepted
* RCPT TO is accepted
* Message appears in Microsoft 365 message trace
* Recipient receives the email

Anything less is **not validated**.

---

## Required Validation Levels

### Level 1: Network Connectivity

Confirm:

* DNS resolution of SMTP endpoint
* TCP connectivity to configured port
* No immediate firewall blocks

Tools:

* `Test-NetConnection`
* Firewall logs (if available)

This confirms reachability only, not delivery.

---

### Level 2: SMTP Capability Validation

Confirm:

* SMTP banner is returned
* EHLO response received
* Expected capabilities advertised:

  * STARTTLS (if required)
  * SIZE
  * PIPELINING

This confirms protocol negotiation only.

---

### Level 3: TLS Validation (If Enabled)

Confirm:

* STARTTLS advertised
* TLS handshake completes
* Supported TLS version and cipher negotiated
* Re-EHLO succeeds after TLS

TLS success rules out MTU and packet fragmentation as primary causes.

---

### Level 4: Envelope Acceptance (Critical)

Manually test:

* `MAIL FROM`
* `RCPT TO`

This step determines whether Microsoft 365 will **accept** the message.

Common failures discovered here:

* IP reputation blocks
* Recipient policy rejections
* Connector scope mismatches

Connector validation tests do not cover this stage.

---

### Level 5: Message Trace Verification

In Exchange Admin Center:

* Search for the message
* Confirm it is logged
* Review delivery status

If no trace exists, the message was rejected before acceptance.

---

## Recommended Test Order

Always test in this order:

1. Network connectivity
2. SMTP banner and EHLO
3. STARTTLS
4. MAIL FROM / RCPT TO
5. Message trace

Skipping steps often leads to incorrect conclusions.

---

## Control Tests

When troubleshooting:

* Always test SMTP Submission (587) as a control
* If submission works, focus on port 25/IP reputation
* If submission fails, focus on credentials or TLS

Control tests prevent wasted effort.

---

## Documentation Requirements

For each SMTP issue, record:

* SMTP method used
* Server and port
* Encryption settings
* Authentication method
* Error messages
* Final working configuration

This creates reusable institutional knowledge.

---

## Key Takeaways

* “Test email sent” does not mean delivered
* STARTTLS success does not imply acceptance
* RCPT TO is where many failures occur
* Validation requires both protocol and application-layer confirmation
* SMTP Submission provides the most predictable results

---

End of document.

---
