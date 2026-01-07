# SMTP Testing Procedure – Microsoft 365 and MFP Devices

---

## Purpose

This document outlines a repeatable, step-by-step procedure for testing SMTP connectivity, TLS negotiation, and message acceptance when troubleshooting scan-to-email issues with Microsoft 365 and multifunction printers (MFPs).

The goal is to move beyond basic “connection tests” and validate actual mail acceptance behavior.

---

## When to Use This Procedure

Use this procedure when:

* Scan-to-email fails with generic errors
* Microsoft 365 connector validation passes but mail does not deliver
* No errors appear in Exchange message trace
* STARTTLS appears to succeed but delivery still fails
* Port 25 or Direct Send is being evaluated

---

## Prerequisites

* PowerShell 5.1 or newer
* Outbound connectivity to Microsoft 365 SMTP endpoints
* A test sender and recipient address in the tenant
* Access to firewall logs if available

---

## Step 1: Basic Connectivity Check

Verify the SMTP endpoint is reachable.

Test ports as applicable:

* Port 25 (Direct Send / MX)
* Port 587 (SMTP Submission)

Confirm DNS resolution and TCP connectivity before proceeding.

---

## Step 2: EHLO Capability Test

Perform an SMTP banner and EHLO test to confirm:

* Server responds correctly
* EHLO is accepted
* STARTTLS is advertised (if expected)

Important notes:

* EHLO success does not mean mail will be accepted
* Connector validation tests stop at this stage

---

## Step 3: STARTTLS Negotiation

If STARTTLS is advertised:

* Issue STARTTLS
* Confirm server returns 220 ready response
* Upgrade connection to TLS
* Validate protocol and cipher negotiation
* Re-issue EHLO after TLS

If STARTTLS fails, investigate firewall inspection, MTU, or TLS policy issues.

---

## Step 4: MAIL FROM / RCPT TO Test

This is the most critical step.

Send the following commands:

* MAIL FROM
* RCPT TO

Observe server responses carefully.

Key outcomes:

* 250 responses indicate acceptance
* 5xx responses indicate policy or reputation blocks
* IP reputation failures often occur at RCPT TO

This stage exposes issues that are invisible in connector validation.

---

## Step 5: Analyze Failures

Common failure patterns:

### IP Reputation Block

* Rejection occurs at RCPT TO
* Error references Spamhaus or similar
* Indicates Direct Send is not viable from this IP

### Authentication Required

* Server expects SMTP AUTH
* Occurs when using port 587 without credentials

### TLS Enforcement Failure

* STARTTLS required but not negotiated
* Often caused by device limitations or firewall inspection

---

## Step 6: Choose Correct SMTP Method

Based on results:

* If IP reputation block occurs, abandon Direct Send
* Prefer SMTP Submission with authentication
* Use a dedicated mailbox for MFPs
* Enable SMTP AUTH only where required

---

## Step 7: Verify End-to-End Delivery

After configuration changes:

* Send test scans
* Confirm messages appear in Exchange message trace
* Verify delivery to mailbox
* Monitor for repeat failures

---

## Key Lessons

* SMTP connectivity does not equal mail acceptance
* STARTTLS success does not guarantee delivery
* Connector tests are incomplete by design
* Full SMTP conversations reveal hidden failures
* Authenticated SMTP is the most reliable option for MFPs

