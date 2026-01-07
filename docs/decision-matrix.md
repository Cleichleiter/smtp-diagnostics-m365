# SMTP Method Decision Matrix for Microsoft 365 and MFP Devices

---

## Purpose

This matrix provides a concise, decision-oriented comparison of the three Microsoft 365 SMTP options commonly used for multifunction printers (MFPs). It is intended for quick reference during troubleshooting, design decisions, and client discussions.

---

## Summary Comparison

| Method          | Port | Auth Required | Depends on IP Reputation | Reliability | Recommended Use                   |
| --------------- | ---- | ------------- | ------------------------ | ----------- | --------------------------------- |
| Direct Send     | 25   | No            | Yes                      | Low–Medium  | Limited, controlled scenarios     |
| SMTP Relay      | 25   | No            | Yes                      | Medium      | Static IP enterprise environments |
| SMTP Submission | 587  | Yes           | No                       | High        | Default for most MFPs             |

---

## Direct Send (MX Endpoint)

**Description:**
Device sends mail directly to the tenant’s MX endpoint without authentication.

**Requirements:**

* Port 25 outbound
* Source IP allowed by Microsoft 365
* Clean IP reputation

**Pros:**

* Simple configuration
* No credentials stored on device

**Cons:**

* Highly sensitive to IP reputation
* Often blocked by ISPs
* Failures may occur at RCPT TO
* Poor diagnostics in connector tests

**Use When:**

* Static, enterprise-owned public IP
* Low volume
* Controlled environment

**Avoid When:**

* Residential or dynamic IPs
* MSP-managed edge devices
* Reliability is required

---

## SMTP Relay (Connector-Based)

**Description:**
Device relays mail through Microsoft 365 using a connector scoped to source IPs or domains.

**Requirements:**

* Port 25 outbound
* Connector correctly scoped
* Clean, static public IP

**Pros:**

* No device authentication required
* Centralized connector control

**Cons:**

* Still dependent on IP reputation
* Connector validation does not guarantee delivery
* Troubleshooting can be opaque

**Use When:**

* Enterprise networks with static IPs
* Multiple devices relaying from known locations

**Avoid When:**

* ISP-assigned IPs
* Environments with frequent IP changes

---

## SMTP Submission (Authenticated SMTP)

**Description:**
Device authenticates to Microsoft 365 using a mailbox over port 587 with STARTTLS.

**Requirements:**

* Port 587 outbound
* SMTP AUTH enabled on mailbox
* Credentials configured on device

**Pros:**

* Not dependent on IP reputation
* Predictable behavior
* Strong auditability
* Microsoft-recommended for devices

**Cons:**

* Credentials stored on device
* SMTP AUTH uses basic auth
* MFA not supported

**Use When:**

* MFP devices
* MSP-managed environments
* Reliability and supportability matter

**Avoid When:**

* Authentication is strictly prohibited on devices

---

## Default Recommendation

For most environments:

**Use SMTP Submission (587)**

Only consider port 25–based methods when there is a clear, justified requirement and a clean, static IP under organizational control.

---

## Key Takeaways

* IP-based trust is fragile
* Authentication provides stability
* Connector tests do not equal delivery
* Port 587 is the safest default for MFPs
* Design for reliability, not convenience

