# Real-World Failure Case: <Short, Descriptive Title>

---

## Summary

Briefly describe the problem, the affected system or device, and the final outcome. This section should explain *what failed* and *why it mattered* in 3–5 sentences.

---

## Environment

* Device / Application:
* Function (e.g., Scan to Email, App Relay):
* SMTP Method Attempted:
* Microsoft 365 Tenant: `<tenant-domain>`
* Firewall / Network Device:
* Public IP Type (static, dynamic, residential, datacenter):
* SMTP Endpoint:
* Port:
* Encryption Method:

---

## Initial Symptoms

Describe what the user or system reported. Include observable behavior only.

*
*
*

---

## Investigation Timeline

### Network / Firewall

*
*

### TLS / Encryption

*
*

### Authentication / Policy

*
*

### Other Factors Considered

*
*

---

## Diagnostic Testing Performed

List **specific tests**, tools, or scripts used.

Examples:

* EHLO / STARTTLS probe
* MAIL FROM / RCPT TO validation
* MTU path testing
* Connector validation
* Message trace review

---

## Definitive Failure Point

State **exactly where** the process failed.

* SMTP stage (e.g., CONNECT, STARTTLS, MAIL FROM, RCPT TO, DATA)
* Exact error message (sanitized if needed)

Example:

```
<error message here>
```

---

## Root Cause

Clearly explain **why** the failure occurred. This should be factual and evidence-based.

---

## Resolution

Describe the action taken that resolved the issue.

Include:

* Configuration changes
* Method change (e.g., Direct Send → SMTP Submission)
* Policy adjustments

---

## Why This Resolution Worked

Explain *why* the fix addressed the root cause.

---

## Lessons Learned

*
*
*

---

## Recommendations for Future Deployments

Actionable guidance to prevent recurrence.

*
*
*

---

## Related Artifacts

List any related files, scripts, or documents.

Examples:

* `scripts/<script-name>.ps1`
* `docs/<doc-name>.md`
* Ticket number / internal reference (if applicable)

---

End of document.

