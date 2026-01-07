# Ticket Notes – Scan to Email Failure (Microsoft 365 / Sharp MX)

---

## Ticket Summary

Customer reported scan-to-email failures from a Sharp MX-series copier. Device displayed generic communication and authentication errors. No email messages were being delivered to Microsoft 365 mailboxes.

---

## Environment

* Device: Sharp MX-4070N
* Function: Scan to Email
* Firewall: UniFi UDM Pro
* Microsoft 365 tenant: [redacted]
* Initial SMTP method: Direct Send / SMTP Relay (Port 25)
* Public IP: ISP-assigned (non-dedicated)

---

## Initial Symptoms

* Copier test email intermittently fails
* “Connection failed” or “Authentication failed” errors shown on device
* Microsoft 365 connector validation tests pass
* No messages appear in Exchange message trace
* No visible errors in Exchange Admin Center

---

## Troubleshooting Performed

### Network and Connectivity

* Verified DNS resolution of Microsoft 365 SMTP endpoints
* Confirmed outbound TCP connectivity to port 25
* No UniFi Threat Management or IDS/IPS blocks observed
* Firewall bypass rules tested with no change in behavior

### MTU and Fragmentation Testing

* Performed MTU path testing using ICMP DF probes
* TLS handshake consistently succeeded
* MTU issues ruled out as primary cause

### SMTP Capability and TLS Validation

* SMTP banner and EHLO responses confirmed
* STARTTLS advertised by Microsoft 365 MX endpoint
* TLS 1.3 successfully negotiated
* Re-EHLO after TLS succeeded

### Connector Verification

* Outbound connector reviewed and validated
* Domain scope confirmed correct
* Connector test email succeeded

Despite all checks passing, delivery failures persisted.

---

## Definitive Diagnostic Test

Performed a full manual SMTP conversation using PowerShell:

* EHLO
* STARTTLS
* MAIL FROM
* RCPT TO

### Result

At the RCPT TO stage, Microsoft 365 returned:

```
550 5.7.1 Service unavailable, Client host blocked using Spamhaus
```

This rejection did not appear in connector validation tests and only surfaced during an actual SMTP delivery attempt.

---

## Root Cause

Microsoft 365 rejected messages due to **IP reputation enforcement** on port 25.

Key factors:

* Source IP was ISP-assigned and not dedicated
* Spamhaus listing applied to the public IP
* Rejection occurred at RCPT TO, not connection or TLS stage
* STARTTLS success did not indicate mail acceptance

---

## Resolution

Switched from Direct Send / SMTP Relay to **SMTP Submission (Authenticated SMTP)**.

### Final Working Configuration

* SMTP Server: `smtp.office365.com`
* Port: 587
* Encryption: STARTTLS
* Authentication: Enabled
* Mailbox: Dedicated scan mailbox
* SMTP AUTH: Enabled on mailbox
* MFA: Not applied to SMTP AUTH

After configuring credentials on the copier, scan-to-email succeeded immediately.

---

## Validation

* Test emails successfully delivered
* Messages visible in Exchange message trace
* No further errors observed on device
* Configuration confirmed stable

---

## Lessons Learned

* Connector validation tests do not simulate real delivery
* IP reputation blocks may only appear at RCPT TO
* Port 25 is unreliable without a clean, static IP
* SMTP Submission provides predictable results for MFPs
* Manual SMTP testing is critical for accurate diagnosis

---

## Final Recommendation

Use **SMTP Submission (Port 587)** for MFP devices unless there is a documented requirement for port 25 and a dedicated enterprise IP address.

---

End of document.

