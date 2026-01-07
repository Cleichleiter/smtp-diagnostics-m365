# Microsoft 365 SMTP Behavior – What Actually Happens

## Purpose

This document explains **how Microsoft 365 handles SMTP traffic** and why legacy devices (copiers, scanners, applications) frequently fail when configured incorrectly. It is written to eliminate guesswork and clarify **what is supported vs. what merely appears to work**.

---

## SMTP Endpoints in Microsoft 365

Microsoft 365 exposes **two very different SMTP paths**, each with specific rules and expectations.

### 1. MX Endpoint (Port 25)

**Example**

```
<tenant>-com.mail.protection.outlook.com
```

**Primary purpose**

* Receiving inbound mail **from the internet**
* Not intended for authenticated client submission

**Key characteristics**

* No SMTP AUTH
* IP reputation enforced (Spamhaus, Microsoft filtering)
* STARTTLS may be advertised, but does **not** imply acceptance
* MAIL FROM may succeed
* RCPT TO may fail due to policy or reputation
* Connectivity tests may pass while delivery fails

**Common misconception**

> “The connection test passed, so email should work.”

This is false. A successful TCP or EHLO response does **not** mean Microsoft will accept or deliver mail.

---

### 2. SMTP AUTH Submission Endpoint (Port 587)

**Endpoint**

```
smtp.office365.com
```

**Primary purpose**

* Authenticated mail submission from devices and applications

**Key characteristics**

* Requires STARTTLS
* Requires valid SMTP AUTH credentials
* Not dependent on public IP reputation
* Supports modern TLS and policy enforcement
* Supported and documented by Microsoft

This is the **only supported method** for sending outbound mail from devices that cannot use OAuth.

---

## STARTTLS: What It Means (and What It Doesn’t)

STARTTLS simply indicates that:

* The server is willing to negotiate encryption
* The client *may* upgrade the connection

STARTTLS **does not guarantee**:

* Message acceptance
* Recipient acceptance
* Policy approval
* Reputation bypass

STARTTLS protects the transport — **not your eligibility to send mail**.

---

## Why Port 25 Fails in Real-World Scenarios

Port 25 failures typically occur due to one or more of the following:

### IP Reputation Enforcement

* Microsoft uses Spamhaus and internal reputation systems
* Residential ISPs and cellular ISPs are frequently blocked
* Even business connections can be flagged

**Typical error**

```
550 5.7.1 Client host blocked using Spamhaus
```

### Policy Enforcement

* Unauthenticated senders are restricted
* Tenant-level protections apply even for “internal” addresses

### False Positives from Device Tests

* Many copiers only test TCP connectivity
* Some test EHLO but never attempt RCPT TO
* Failures only appear during actual mail delivery

---

## Why SMTP AUTH on MX Endpoints Fails

MX endpoints **do not support SMTP AUTH**.

If SMTP AUTH is enabled on a device while using an MX endpoint:

* Authentication will fail
* Errors may be misleading
* Some devices will silently retry without auth

This often leads to the incorrect conclusion that “auth is broken.”

---

## Why Removing SMTP AUTH “Fixes” Things Temporarily

Disabling SMTP AUTH may allow:

* Connection tests to pass
* MAIL FROM to succeed

However:

* RCPT TO is still subject to reputation filtering
* Delivery remains unreliable or fully blocked
* This configuration is **unsupported and fragile**

This is a diagnostic signal, not a solution.

---

## Microsoft-Supported Configurations

### Supported

* `smtp.office365.com`
* Port `587`
* STARTTLS enabled
* SMTP AUTH enabled
* Valid licensed mailbox or app password

### Unsupported / Not Recommended

* MX endpoint for outbound mail
* Port 25 from legacy devices
* Unauthenticated SMTP submission
* Relying on IP allowlists to bypass policy

---

## Key Takeaways

* SMTP connectivity ≠ mail delivery
* STARTTLS ≠ permission to send
* MX endpoints are not submission servers
* Port 25 is reputation-sensitive by design
* Port 587 with SMTP AUTH is the correct solution

---

## When to Use This Document

Use this reference when:

* A copier vendor blames the firewall
* An ISP claims “port 25 is open”
* A client says “it worked before”
* SMTP tests pass but mail never arrives
* You need protocol-level justification for a configuration change

---

## Bottom Line

If a device cannot authenticate, it should **not** be sending mail through Microsoft 365.
If a device can authenticate, **port 587 is the only supported path**.

Anything else is technical debt waiting to fail again.
