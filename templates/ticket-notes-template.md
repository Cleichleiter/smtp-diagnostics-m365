# Ticket Notes – SMTP / Scan-to-Email Troubleshooting

---

## Ticket Information

* Client:
* Site / Location:
* Device:
* Issue Reported:
* Date Opened:
* Engineer:

---

## Problem Description

Client reported that scan-to-email from the copier was failing. Users were able to scan documents, but emails were not being delivered to internal Microsoft 365 mailboxes. Copier displayed generic communication or authentication errors.

No corresponding failures were visible in Microsoft 365 message trace.

---

## Initial Assessment

Confirmed the following:

* Copier had network connectivity
* DNS resolution was functioning
* SMTP endpoint reachable
* No immediate firewall blocks observed

Issue required deeper SMTP-level troubleshooting.

---

## Troubleshooting Performed

### Network and Firewall

* Verified outbound connectivity to Microsoft 365 SMTP endpoints
* Confirmed ports 25 and 587 reachable
* Reviewed UniFi UDM Pro firewall rules
* Temporarily bypassed IDS/IPS and threat inspection for testing
* No firewall drops or threat events observed

### MTU and Packet Fragmentation

* Performed MTU path testing using ICMP with DF bit
* Tested multiple payload sizes
* TLS handshake success confirmed
* MTU issues ruled out as root cause

### SMTP Capability Testing

* Verified SMTP banner and EHLO responses
* Confirmed STARTTLS availability on port 25
* Successfully negotiated TLS 1.3
* Re-issued EHLO after TLS upgrade
* Confirmed server capabilities post-TLS

### Full SMTP Conversation Test

Performed a manual SMTP conversation using PowerShell, including:

* EHLO
* STARTTLS
* MAIL FROM
* RCPT TO

Observed rejection at RCPT TO stage with explicit IP reputation block message referencing Spamhaus.

This error does not appear in Microsoft 365 connector validation tests and only surfaces during live message submission.

---

## Root Cause

Microsoft 365 rejected the sending host due to public IP reputation enforcement.

Key findings:

* Direct Send (port 25) is subject to IP reputation checks
* IP was listed by Spamhaus
* Rejection occurred at RCPT TO stage
* STARTTLS and connection success did not indicate message acceptance
* Residential/dynamic IPs are not reliable for SMTP relay

---

## Resolution Implemented

Reconfigured the copier to use authenticated SMTP submission.

Configuration changes:

* SMTP server changed to smtp.office365.com
* Port changed to 587
* Encryption set to STARTTLS
* Dedicated mailbox credentials configured on device
* SMTP AUTH enabled for mailbox
* MFA removed or bypassed for SMTP

After changes, scan-to-email succeeded immediately.

---

## Verification

* Test scans successfully delivered
* Messages visible in Microsoft 365 message trace
* No further errors reported by users

---

## Recommendations

* Use SMTP submission with authentication for all copiers
* Avoid port 25 Direct Send unless a clean static IP is available
* Do not rely solely on connector validation tests
* Perform full SMTP conversation testing for future mail flow issues

---

## Ticket Status

Resolved.
