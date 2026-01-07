Real-World Failure Case: Microsoft 365 MX Relay Blocked by IP Reputation
Summary

A Sharp MX-series copier was unable to send scan-to-email messages using Microsoft 365 Direct Send (MX endpoint on port 25). Despite successful network connectivity, STARTTLS negotiation, and connector validation, email delivery consistently failed.

The root cause was an IP reputation block enforced by Microsoft 365 at the RCPT TO stage, based on third-party blocklists (e.g., Spamhaus).

Environment

Device: Sharp MX-4070N (MX-series MFP)

Function: Scan to Email

SMTP Method Attempted: Direct Send (MX endpoint)

Microsoft 365 Tenant: <tenant-domain>

Firewall: UniFi UDM Pro

Public IP Type: ISP-assigned / non-dedicated

SMTP Endpoint: <tenant-domain>.mail.protection.outlook.com

Port: 25

Encryption: STARTTLS

Initial Symptoms

Copier reports generic “communication error” or “connection failed”

Microsoft 365 connector validation test succeeds

SMTP banner and EHLO succeed

STARTTLS negotiation succeeds

No message appears in Exchange message trace

No visible errors in Exchange Admin Center

False Leads Investigated and Ruled Out
Network / Firewall

Port 25 connectivity confirmed

No IDS/IPS blocks observed

No UniFi Threat Management rules triggering

Firewall bypass rules tested with no change

MTU / Fragmentation

MTU path testing performed

No consistent fragmentation failures identified

TLS handshake succeeded, ruling out MTU as the primary cause

TLS / Cipher Issues

STARTTLS advertised by the server

TLS successfully negotiated

Cipher suite accepted

EHLO succeeded after TLS upgrade

Connector Configuration

Outbound connector correctly configured

Domain scope verified

Connector validation test passed

Despite all of the above, delivery continued to fail.

Definitive Diagnostic Test

A full SMTP conversation was performed manually using PowerShell, including:

EHLO

STARTTLS

MAIL FROM

RCPT TO

Result at RCPT TO Stage
550 5.7.1 Service unavailable, Client host [x.x.x.x] blocked using Spamhaus


This error does not appear during connector validation tests and only surfaces during an actual SMTP delivery attempt.

Root Cause

Microsoft 365 rejected the sending host based on source IP reputation.

Key observations:

Direct Send and SMTP Relay are subject to IP reputation enforcement

Reputation checks occur at the RCPT TO stage, not during connection or TLS negotiation

Successful STARTTLS does not imply message acceptance

Non-dedicated or residential IP ranges are high risk for port 25 relay

Resolution

The resolution was to abandon Direct Send and switch to SMTP Submission (Authenticated SMTP).

Working Configuration

Server: smtp.office365.com

Port: 587

Encryption: STARTTLS

Authentication: Dedicated service mailbox

SMTP AUTH: Enabled on mailbox

MFA: Disabled or bypassed for SMTP

After enabling SMTP AUTH and supplying credentials to the device, scan-to-email succeeded immediately.

Why SMTP Submission Worked

SMTP Submission does not rely on source IP reputation

Authentication establishes trust independent of IP

Port 587 is not commonly filtered by ISPs

Microsoft recommends SMTP Submission for multifunction devices

Lessons Learned

Connector validation tests do not simulate real SMTP delivery

STARTTLS success does not guarantee mail acceptance

IP reputation failures may only appear at RCPT TO

Port 25 relay is fragile outside of enterprise-grade static IP environments

SMTP Submission is typically the most reliable option for MFP devices

Recommendation

For Sharp MX-series devices and similar multifunction printers:

Use SMTP Submission (port 587) whenever possible

Avoid Direct Send unless using a clean, static public IP

Do not over-invest in port 25 troubleshooting if SMTP Submission works

Always validate delivery with a full SMTP conversation test

End of document.