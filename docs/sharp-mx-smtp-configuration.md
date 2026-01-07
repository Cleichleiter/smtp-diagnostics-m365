# Sharp MX Series – Microsoft 365 SMTP Configuration (Validated)

## Scope

This document provides validated SMTP configuration guidance for Sharp MX-series multifunction devices (including MX-4070N) when sending scan-to-email through Microsoft 365 / Exchange Online.

The guidance is based on protocol-level testing, Microsoft-supported behavior, and real-world failure analysis.

---

## Supported SMTP Method (Required)

Microsoft 365 requires authenticated submission for outbound mail from devices.

### Supported Configuration

| Setting             | Value                                                   |
| ------------------- | ------------------------------------------------------- |
| SMTP Server         | `smtp.office365.com`                                    |
| Port                | `587`                                                   |
| Encryption          | STARTTLS                                                |
| SMTP Authentication | Enabled                                                 |
| Username            | Full mailbox address (for example, `office@domain.com`) |
| Password            | App password or mailbox credentials                     |
| Sender Address      | Same as authenticated mailbox                           |

This is the only supported configuration for Sharp devices using Microsoft 365.

---

## Unsupported or Problematic Configurations

### MX Endpoint (Port 25)

```
<tenant>-com.mail.protection.outlook.com
```

**Why this fails**

* MX endpoints are designed for inbound mail
* SMTP authentication is not supported
* IP reputation is enforced (Spamhaus and Microsoft filtering)
* STARTTLS availability does not imply message acceptance
* Connection tests may pass while delivery fails

**Typical failure**

```
550 5.7.1 Client host blocked using Spamhaus
```

---

### Disabling SMTP Authentication

Disabling SMTP authentication may allow:

* SMTP connection tests to pass
* Temporary indications of success

However:

* Mail delivery remains blocked or unreliable
* The configuration is unsupported
* Failures will recur

This behavior should be treated as a diagnostic signal, not a solution.

---

## Sharp MX Embedded Web Server Configuration

### Accessing SMTP Settings

1. Open the copier IP address in a web browser
2. Log in as administrator
3. Navigate to:

```
Network Settings
→ Services Settings
→ SMTP
```

Important: Do not rely on **Quick Settings → SMTP**. Advanced SMTP options such as port, TLS, and authentication behavior are only available under **Services Settings**.

---

### Required SMTP Settings

| Field               | Value                |
| ------------------- | -------------------- |
| SMTP Server         | `smtp.office365.com` |
| Port Number         | `587`                |
| Enable SSL          | Enabled              |
| SSL/TLS Level       | STARTTLS             |
| SMTP Authentication | Enabled              |
| User Name           | `office@domain.com`  |
| Password            | Valid credentials    |
| POP before SMTP     | Disabled             |
| Sender Address      | `office@domain.com`  |

---

## Authentication Notes

* Sharp MX devices do not support OAuth
* Use one of the following:

  * App password (recommended)
  * Dedicated licensed mailbox
* The sender address must match the authenticated mailbox
* Alias addresses may fail depending on tenant policy

---

## Verification Checklist

After configuration:

1. Run the SMTP connection test on the Sharp device
2. Send a test scan to an internal mailbox
3. Optionally send a test scan to an external address
4. Confirm delivery in the mailbox
5. If failure occurs:

   * Run the PowerShell SMTP diagnostics in this repository
   * Do not assume firewall or ISP issues without protocol-level evidence

---

## Common Misleading Indicators

| Indicator                    | Actual Meaning                                  |
| ---------------------------- | ----------------------------------------------- |
| Connection test succeeded    | TCP connectivity only                           |
| STARTTLS advertised          | Encryption is available, not permission to send |
| MAIL FROM accepted           | Does not guarantee recipient acceptance         |
| Works without authentication | Temporary or policy-dependent behavior          |

---

## Known Failure Scenarios

| Scenario                                 | Result                 |
| ---------------------------------------- | ---------------------- |
| MX endpoint on port 25                   | Message rejected       |
| SMTP authentication enabled on MX        | Authentication failure |
| Port 25 from residential or cellular ISP | Spamhaus block         |
| STARTTLS without authentication          | Rejected at RCPT stage |
| Correct port 587 configuration           | Supported and reliable |

---

## Troubleshooting Guidance

If scan-to-email fails after applying supported settings:

1. Validate mailbox credentials independently
2. Confirm SMTP authentication is enabled for the mailbox
3. Review Conditional Access exclusions if applicable
4. Run the diagnostic scripts in the `scripts` folder
5. Capture SMTP rejection messages for documentation and escalation

---

## Summary

* Sharp MX devices must use SMTP authentication
* Microsoft 365 does not support unauthenticated outbound SMTP
* Port 587 with STARTTLS is required
* MX endpoints are not submission servers
* Successful connection tests do not guarantee mail delivery

This configuration aligns with Microsoft support guidance and has been validated using direct SMTP conversation testing.
