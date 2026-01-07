# Security Considerations for SMTP and MFP Devices in Microsoft 365

---

## Overview

Multifunction printers (MFPs) often require SMTP access to send scanned documents via email. These devices present unique security challenges due to limited authentication options, outdated firmware, and constrained TLS implementations.

This document outlines security considerations and best practices when integrating MFP devices with Microsoft 365.

---

## SMTP Methods and Security Implications

### Direct Send (Port 25)

**Characteristics:**

* No authentication
* Relies on source IP trust
* Subject to IP reputation enforcement
* Often blocked by ISPs or cloud providers

**Security Risks:**

* Susceptible to IP-based abuse
* Breaks when IP reputation degrades
* Difficult to audit or attribute usage
* Fragile outside of static enterprise IP ranges

**Recommendation:**

Avoid Direct Send unless the source IP is static, clean, and enterprise-managed.

---

### SMTP Submission (Port 587)

**Characteristics:**

* Requires authentication
* Encrypted with STARTTLS
* Not dependent on source IP reputation
* Explicitly supported by Microsoft for devices

**Security Benefits:**

* Strong identity-based trust
* Predictable behavior across networks
* Better logging and traceability
* Resistant to ISP and reputation filtering

**Recommendation:**

Preferred method for MFP devices.

---

## SMTP AUTH Considerations

### Risks

* SMTP AUTH uses basic authentication
* Credentials may be stored on the device
* MFA is not supported for SMTP AUTH

### Mitigations

* Use a dedicated mailbox for each device or site
* Apply a strong, unique password
* Restrict mailbox permissions
* Disable interactive sign-in for the mailbox
* Monitor sign-in logs for anomalies

---

## Conditional Access and SMTP

* Conditional Access policies do not apply to SMTP AUTH
* SMTP AUTH bypasses MFA requirements
* Policies must be scoped carefully to avoid unintended exposure

Best practice is to enable SMTP AUTH only on specific mailboxes and disable it tenant-wide if possible.

---

## Firewall and Network Controls

* Limit outbound SMTP traffic to required ports only
* Avoid unnecessary firewall bypass rules
* Do not disable IDS/IPS without justification
* Log SMTP traffic when troubleshooting

---

## TLS and Encryption

* Always require STARTTLS when supported
* Avoid plaintext SMTP where possible
* Validate that devices support modern TLS versions
* Be aware that some legacy devices may not support TLS 1.2+

---

## Logging and Auditing

* Monitor Exchange message trace
* Review Azure AD sign-in logs for SMTP AUTH usage
* Track device-generated email volumes
* Alert on abnormal sending patterns

---

## Key Takeaways

* Authentication-based SMTP is more secure than IP-based trust
* Direct Send introduces reliability and security risks
* SMTP AUTH should be tightly scoped and monitored
* MFP devices require compensating controls due to limitations
* Security and reliability improve when identity is enforced

