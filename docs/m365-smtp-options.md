# Microsoft 365 SMTP Options – Overview and Use Cases

This document outlines the supported SMTP options in Microsoft 365, how they differ, and when each should be used—particularly for multifunction devices (MFPs) such as Sharp MX-series copiers.

---

## Overview of SMTP Options

Microsoft 365 supports three primary methods for sending email from devices and applications:

1. **SMTP Submission (Authenticated SMTP)**
2. **Direct Send (MX Endpoint)**
3. **SMTP Relay via Connector**

Each option has different requirements, security characteristics, and compatibility considerations.

---

## Option 1: SMTP Submission (Authenticated SMTP)

### Description

SMTP Submission uses user credentials to authenticate directly to Microsoft 365 using `smtp.office365.com` on port 587 with STARTTLS.

### Connection Details

* Server: `smtp.office365.com`
* Port: 587
* Encryption: STARTTLS (TLS 1.2+)
* Authentication: Username and password
* Sender address: Must match or be allowed for the authenticated user

### Requirements

* SMTP AUTH must be enabled at the tenant level
* SMTP AUTH must be enabled on the specific mailbox
* Account must have a valid license (typically Business Basic or higher)
* MFA is not supported directly by most devices

### Pros

* Works from any public IP
* Not dependent on IP reputation
* Does not require connectors or firewall allowlists
* Most reliable option for copiers and legacy devices

### Cons

* Uses credentials stored on the device
* MFA must be disabled or bypassed for the mailbox
* Less desirable from a zero-trust perspective

### Best Use Case

* Copiers and scanners that support SMTP AUTH
* Environments without static public IPs
* Situations where reliability is more important than IP-based trust

---

## Option 2: Direct Send (MX Endpoint)

### Description

Direct Send allows devices to send mail directly to the Microsoft 365 MX endpoint for the tenant without authentication.

### Connection Details

* Server: `<tenant-domain>.mail.protection.outlook.com`
* Port: 25
* Encryption: STARTTLS (required)
* Authentication: None
* Sender address: Must be an accepted domain in the tenant

### Requirements

* Static public IP with good reputation
* Outbound port 25 allowed
* Device must support STARTTLS
* Recipient must be internal to the tenant

### Pros

* No credentials stored on the device
* Simple configuration
* No mailbox licensing required

### Cons

* Subject to IP reputation checks (Spamhaus, etc.)
* Cannot send to external recipients
* Port 25 frequently blocked or inspected by ISPs
* Troubleshooting failures can be non-obvious

### Best Use Case

* Servers or devices on trusted, clean static IPs
* Internal-only email delivery
* Environments with strict credential handling policies

---

## Option 3: SMTP Relay via Connector

### Description

SMTP Relay uses a Microsoft 365 Exchange connector to allow unauthenticated SMTP traffic from specific IPs or domains.

### Connection Details

* Server: `<tenant-domain>.mail.protection.outlook.com`
* Port: 25
* Encryption: STARTTLS (required)
* Authentication: IP-based or certificate-based
* Sender address: Any address in accepted domains

### Requirements

* Exchange connector configured (From: Your org → To: Microsoft 365)
* Public IP allowlisted in connector
* STARTTLS supported by the sending device
* Outbound port 25 allowed

### Pros

* No credentials on the device
* Can send to internal and external recipients
* Centralized control via Exchange Admin Center

### Cons

* Still subject to IP reputation checks
* More complex setup
* Port 25 dependency
* Certificate-based auth rarely supported by copiers

### Best Use Case

* Applications or devices that cannot authenticate
* Environments with stable, reputable public IPs
* Centralized relay scenarios

---

## Sharp MX-Series Compatibility Considerations

| Feature                | Support       |
| ---------------------- | ------------- |
| SMTP AUTH              | Supported     |
| STARTTLS               | Supported     |
| TLS version control    | Limited       |
| Certificate-based auth | Not supported |
| MFA                    | Not supported |
| OAuth                  | Not supported |

Due to these limitations, Sharp MX devices most reliably function with **SMTP Submission (port 587)** using a dedicated mailbox with SMTP AUTH enabled.

---

## Security and Reliability Comparison

| Method          | Credentials | IP Reputation | External Mail | Reliability |
| --------------- | ----------- | ------------- | ------------- | ----------- |
| SMTP Submission | Yes         | No            | Yes           | High        |
| Direct Send     | No          | Yes           | No            | Medium      |
| SMTP Relay      | No          | Yes           | Yes           | Medium      |

---

## Recommendation Summary

* **Preferred (most reliable):** SMTP Submission (587)
* **Conditional:** SMTP Relay (static IP, clean reputation)
* **Use with caution:** Direct Send (MX / port 25)

In environments where scan-to-email must work consistently and troubleshooting time is limited, SMTP Submission is typically the correct choice despite the credential tradeoff.

---

## Notes from Real-World Troubleshooting

* Successful STARTTLS negotiation does not guarantee mail acceptance
* IP reputation blocks may only appear at the RCPT TO stage
* Connector validation tests do not detect Spamhaus or reputation-based rejections
* Switching from Direct Send to SMTP Submission often resolves unexplained failures immediately

---

## References

* Microsoft Docs: How to set up a multifunction device or application to send email using Microsoft 365
* Exchange Admin Center – Connectors
* Sharp MX Administrator Guide (SMTP section)
