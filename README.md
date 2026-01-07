# smtp-diagnostics-m365

## Overview

This repository provides a structured set of **PowerShell-based diagnostics and reference documentation** for troubleshooting SMTP connectivity, STARTTLS negotiation, authentication behavior, and message rejection issues when integrating **legacy devices or applications** (copiers, scanners, LOB apps) with **Microsoft 365 / Exchange Online**.

It is designed to answer questions such as:

* Can the device reach the SMTP endpoint?
* Is STARTTLS advertised and accepted?
* Is SMTP AUTH supported on this endpoint?
* Is the message being rejected due to IP reputation (Spamhaus)?
* Is the failure network-related, authentication-related, or policy-driven?

The focus is **protocol-level proof**, not vendor guesswork.

---

## Common Use Cases

* Scan-to-email failures from copiers (Sharp, Canon, Ricoh, Konica, etc.)
* Legacy applications that cannot use OAuth
* Diagnosing differences between:

  * MX endpoint (port 25)
  * SMTP AUTH submission (port 587)
* Verifying Microsoft 365 SMTP behavior during migrations or ISP changes
* Proving mail rejection cause to ISPs, copier vendors, or clients

---

## Repository Structure

```
smtp-diagnostics-m365
│
├── README.md
│
├── scripts
│   ├── ehlo-probe.ps1
│   ├── starttls-capability-check.ps1
│   ├── mx-vs-auth-comparison.ps1
│   └── smtp-starttls-mailfrom-rcptto-test.ps1
│
├── docs
│   ├── m365-smtp-behavior.md
│   └── sharp-mx-smtp-configuration.md
│
└── examples
    └── real-world-failure-spamhaus.md
```

---

## Scripts

### `ehlo-probe.ps1`

Performs a raw SMTP EHLO probe to enumerate server capabilities such as:

* STARTTLS
* SIZE limits
* PIPELINING
* AUTH (if applicable)

Useful for confirming what a given endpoint *actually* supports.

---

### `starttls-capability-check.ps1`

Validates:

* STARTTLS advertisement
* TLS negotiation success
* TLS version and cipher in use

Confirms whether encryption is available and functional.

---

### `mx-vs-auth-comparison.ps1`

Compares behavior between:

* Microsoft 365 MX endpoint (port 25)
* SMTP AUTH submission endpoint (smtp.office365.com:587)

Highlights why MX is unsuitable for authenticated outbound mail from devices.

---

### `smtp-starttls-mailfrom-rcptto-test.ps1`

Performs a full SMTP conversation:

* EHLO
* STARTTLS
* MAIL FROM
* RCPT TO

Captures **server-side rejection reasons**, including Spamhaus blocks and policy failures.
This script provides definitive proof of why delivery fails.

---

## Documentation

### `docs/m365-smtp-behavior.md`

Explains Microsoft 365 SMTP behavior, including:

* Why MX endpoints do not support SMTP AUTH
* IP reputation enforcement on port 25
* Differences between connectivity success and mail acceptance
* Why STARTTLS alone is not sufficient

---

### `docs/sharp-mx-smtp-configuration.md`

Provides validated SMTP configuration guidance for Sharp MX-series devices, including:

* Correct Microsoft 365 settings
* Common misconfigurations
* Why certain “working” settings are unsupported
* Final recommended configuration

---

## Examples

### `examples/real-world-failure-spamhaus.md`

A sanitized real-world case study showing:

* Initial symptoms
* Diagnostic output
* Microsoft rejection messages
* Root cause determination
* Final resolution

Designed to be reused as evidence in support or escalation scenarios.

---

## Design Principles

* PowerShell 5.1 compatible
* No external modules required
* Explicit, readable output
* Focused on **evidence**, not assumptions
* Safe for production diagnostics (read-only, no mail sent unless explicitly configured)

---

## Intended Audience

* Systems Engineers
* Network Engineers
* MSPs
* IT Administrators supporting Microsoft 365
* Anyone integrating legacy hardware or applications with modern email security controls

---

## Notes

This repository intentionally avoids:

* Client-identifying information
* Credentials
* Vendor-specific assumptions

All scripts and documentation are intended to be **portable, reusable, and defensible**.

---

## License

Internal reference / educational use.
Adapt and reuse as appropriate within your organization.
