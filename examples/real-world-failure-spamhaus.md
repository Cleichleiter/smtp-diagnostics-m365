# Real-World SMTP Failure Example – Spamhaus Block (Microsoft 365)

## Scenario Overview

A Sharp MX-4070N multifunction copier was unable to deliver scan-to-email messages through Microsoft 365. Basic SMTP connectivity tests intermittently succeeded, but scanned documents were never delivered.

This example documents the exact failure mode, the diagnostic evidence, and the validated resolution.

---

## Environment Summary

* Device: Sharp MX-4070N
* Function: Scan to Email
* Email Platform: Microsoft 365 / Exchange Online
* Firewall: UniFi UDM Pro
* ISP: Verizon 5G Home
* Sender Address: `office@domain.com`
* Initial SMTP Endpoint: Microsoft 365 MX (Port 25)

---

## Initial Configuration (Failing)

| Setting             | Value                                      |
| ------------------- | ------------------------------------------ |
| SMTP Server         | `<tenant>-com.mail.protection.outlook.com` |
| Port                | 25                                         |
| STARTTLS            | Enabled                                    |
| SMTP Authentication | Disabled                                   |
| Sender Address      | `office@domain.com`                        |

---

## Observed Symptoms

* Copier SMTP connection test reported success
* STARTTLS was advertised by the server
* No emails were delivered
* No messages appeared in Exchange message trace
* Enabling SMTP authentication caused authentication failures

---

## Diagnostic Testing Performed

### Network Connectivity

* TCP connectivity to port 25 confirmed
* No firewall blocks detected
* UniFi threat management not interfering with SMTP traffic

---

### SMTP Capability Testing

PowerShell scripts were used to perform a full SMTP conversation against the Microsoft 365 MX endpoint.

Confirmed behaviors:

* EHLO succeeded
* STARTTLS advertised
* TLS negotiation succeeded
* MAIL FROM accepted
* RCPT TO rejected

---

### Server Rejection Evidence

During the RCPT stage, Microsoft 365 returned the following error:

```
550 5.7.1 Service unavailable, Client host [PUBLIC_IP] blocked using Spamhaus
```

This confirmed that:

* The message was rejected by Microsoft 365
* The rejection occurred after TLS negotiation
* The failure was caused by IP reputation enforcement
* The issue was not firewall-related
* The issue was not authentication-related at this stage

---

## Key Findings

* MX endpoints do not support SMTP authentication
* STARTTLS does not override reputation enforcement
* Connection tests do not validate mail acceptance
* Residential and cellular ISP IP ranges are commonly blocked on port 25
* Mail can fail silently after successful connection and encryption

---

## Corrective Action

The copier was reconfigured to use Microsoft’s supported SMTP submission endpoint.

### Updated Configuration (Working)

| Setting             | Value                                     |
| ------------------- | ----------------------------------------- |
| SMTP Server         | `smtp.office365.com`                      |
| Port                | 587                                       |
| Encryption          | STARTTLS                                  |
| SMTP Authentication | Enabled                                   |
| Username            | `office@domain.com`                       |
| Password            | Valid mailbox credentials or app password |
| Sender Address      | `office@domain.com`                       |

---

## Validation After Changes

* SMTP connection test succeeded
* SMTP authentication succeeded
* Test scans delivered successfully
* No further rejections observed
* Configuration aligned with Microsoft support guidance

---

## Why This Matters

This case demonstrates why:

* Port 25 is unreliable for outbound mail
* STARTTLS alone is insufficient
* IP reputation can block delivery even when encryption succeeds
* Protocol-level testing is required to determine true root cause

---

## Lessons Learned

* Always test MAIL FROM and RCPT TO, not just connectivity
* Do not rely on copier connection tests as proof of delivery
* Use Microsoft-supported SMTP submission for devices
* Capture server rejection messages before changing infrastructure
* Avoid temporary fixes that disable authentication

---

## Reuse Guidance

This example can be reused when:

* Vendors blame firewalls or ISPs
* Clients claim “it worked before”
* SMTP tests pass but mail never arrives
* Proof is needed for escalation or documentation

---

## Final Outcome

The issue was resolved by switching from an unauthenticated MX-based SMTP configuration to authenticated SMTP submission on port 587. The final configuration is stable, supported, and repeatable.
