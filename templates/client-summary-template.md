# Client Summary: SMTP / Scan-to-Email Issue

---

## Overview

This document provides a concise, client-facing summary of the scan-to-email issue that was investigated, the root cause identified, and the resolution implemented. It is intended for non-technical stakeholders and avoids deep protocol or diagnostic detail.

---

## Issue Summary

The scan-to-email function on the copier was failing to deliver emails to Microsoft 365 recipients. Although the device was able to connect to Microsoft 365’s mail servers, messages were not being accepted for delivery.

No emails appeared in the recipient mailboxes, and no errors were visible in standard Microsoft 365 administrative dashboards.

---

## What Was Investigated

The following areas were reviewed and tested:

* Network connectivity between the copier and Microsoft 365
* Firewall rules and security inspection
* Email server connection and encryption
* Microsoft 365 mail flow configuration
* Device email configuration

All connectivity and security tests initially appeared successful, which made the issue difficult to identify using standard validation tools.

---

## Root Cause (High-Level)

Microsoft 365 was rejecting email messages sent directly from the copier due to the reputation of the site’s public IP address.

This type of rejection does not occur during basic connection testing and only appears when a message is actually submitted for delivery.

---

## Resolution Implemented

The copier was reconfigured to use Microsoft 365’s authenticated SMTP submission service instead of direct mail relay.

This method uses secure authentication rather than relying on the sending IP address and is the recommended approach for multifunction printers.

After this change was made, scan-to-email began working immediately.

---

## Why This Works

Authenticated SMTP submission:

* Uses secure login credentials instead of IP trust
* Is not affected by public IP reputation
* Uses a modern, supported Microsoft 365 mail flow method
* Is more reliable for copier and application-based email

---

## Impact

* Scan-to-email functionality has been fully restored
* No changes were required to user workflows
* No impact to other email services

---

## Recommendation Going Forward

For copiers and similar devices:

* Use authenticated SMTP submission whenever possible
* Avoid direct mail relay unless a dedicated, clean static IP is available
* Treat scan-to-email as an application integration, not simple email sending

---

## Status

Resolved and verified.

---

End of document.

