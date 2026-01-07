# SMTP Troubleshooting Decision Tree (Microsoft 365)

Use this decision tree to diagnose scan-to-email and application SMTP failures with Microsoft 365. Follow the steps in order. Do not skip ahead.

---

## Step 1: Basic Connectivity

**Test**

* TCP connectivity to the configured SMTP host and port

**Expected**

* Port 25 (MX / Relay) or 587 (SMTP Submission) connects successfully

**If this fails**

* Firewall blocking outbound SMTP
* ISP blocking port 25
* Incorrect DNS or hostname
* NAT or routing issue

**Action**

* Verify firewall rules
* Test from the device VLAN and from a workstation on the same network
* Use a TCP connectivity test script

---

## Step 2: SMTP Banner Response

**Test**

* Open TCP connection and wait for `220` banner

**Expected**

* `220 <server> Microsoft ESMTP MAIL Service ready`

**If this fails**

* Middlebox terminating the connection
* TLS inspection interfering
* SMTP blocked upstream

**Action**

* Disable IDS/IPS or SSL inspection for SMTP
* Test from a clean network segment

---

## Step 3: EHLO Response

**Test**

* Send `EHLO <hostname>`

**Expected**

* One or more `250-` capability lines followed by `250 `

**If this fails**

* Device sending `HELO` instead of `EHLO`
* SMTP proxy altering traffic
* TLS enforcement mismatch

**Action**

* Confirm device supports EHLO
* Verify no SMTP proxy or content filter is in path

---

## Step 4: STARTTLS Capability

**Test**

* Check EHLO output for `250-STARTTLS`

**Expected**

* `STARTTLS` is advertised

**If STARTTLS is not offered**

* Wrong endpoint (AUTH vs MX)
* TLS inspection stripping capabilities
* Server policy mismatch

**Action**

* Confirm correct SMTP endpoint
* Disable TLS inspection
* Re-test using a manual SMTP probe

---

## Step 5: STARTTLS Negotiation

**Test**

* Send `STARTTLS`
* Upgrade to TLS
* Re-issue `EHLO`

**Expected**

* `220 Ready to start TLS`
* TLS session established
* EHLO succeeds again post-TLS

**If this fails**

* TLS version mismatch
* Cipher incompatibility
* MTU or fragmentation issues

**Action**

* Force TLS 1.2 if configurable
* Test MTU path
* Bypass IDS/IPS temporarily

---

## Step 6: MAIL FROM Accepted

**Test**

* Send `MAIL FROM:<sender@domain>`

**Expected**

* `250 2.1.0 Sender OK`

**If this fails**

* Sender domain not accepted
* Connector misconfiguration
* Authentication required

**Action**

* Verify accepted domains
* Verify connector direction and scope
* Confirm SMTP AUTH vs relay expectations

---

## Step 7: RCPT TO Accepted

**Test**

* Send `RCPT TO:<recipient@domain>`

**Expected**

* `250 2.1.5 Recipient OK`

**If this fails**

* IP reputation block (Spamhaus, etc.)
* Connector restrictions
* External recipient blocked (Direct Send)

**Common Error**

* `550 5.7.1 Client host blocked using Spamhaus`

**Action**

* Check public IP reputation
* Switch to SMTP Submission (587)
* Request delisting if applicable

---

## Step 8: DATA Phase (Optional)

**Test**

* Send `DATA` and a small test message

**Expected**

* `354 Start mail input`
* `250 2.0.0 Message accepted for delivery`

**If this fails**

* Content filtering
* Message size limits
* Policy enforcement

**Action**

* Reduce attachment size
* Review transport rules
* Review message trace

---

## Common Failure Patterns and Meaning

### STARTTLS Works, MAIL FROM Works, RCPT TO Fails

* IP reputation issue
* Connector test passing does not validate reputation

### SMTP AUTH Works, MX Fails

* Port 25 / IP reputation issue
* Expected behavior

### Connector Test Passes, Device Fails

* Connector test does not simulate real SMTP conversation
* Device TLS or network path differs

---

## Final Guidance

* If **reliability is the priority**, use SMTP Submission (587)
* If **no credentials are allowed**, ensure static IP reputation is clean
* Do not assume STARTTLS success equals delivery success
* Always test RCPT TO to validate real acceptance

---

## Artifacts to Collect for Escalation

* Full SMTP transcript
* Public source IP
* Error codes at RCPT TO
* Microsoft message trace (if applicable)
* MTU test results

---

End of document.
