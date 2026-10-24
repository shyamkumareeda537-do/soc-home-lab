# SOC Incident Response Playbook

## 1. Incident Handling Methodology (NIST SP 800-61 Rev 2)

```
[1. Preparation] ──> [2. Detection & Analysis] ──> [3. Containment, Eradication & Recovery] ──> [4. Post-Incident Activity]
```

---

## 2. Playbook: Brute Force & Suspicious Authentication

### Step 1: Initial Detection & Triage
1. Review the alert triggered in Splunk (e.g., `Brute Force Attempt Detected: TargetUserName = testuser`).
2. Verify the raw event data in the `endpoint` index:
   * Target User Name: Is this a service account, privileged admin, or standard user?
   * Source IP / Workstation Name: Is the attempt originating internally or from an external address?
   * Logon Type: Type 2 (Interactive console), Type 3 (Network SMB/RPC), Type 10 (RDP).
3. Confirm whether any subsequent Event ID 4624 (Logon Success) occurred for the target account.

### Step 2: Evidence Assessment & False Positive Verification
* Did a legitimate user mistype their password repeatedly?
* Is an automated backup script or scheduled task running with expired credentials?
* Did the source workstation match the employee's assigned device?

### Step 3: Containment
1. If unauthorized access is confirmed, disable or lock the compromised account.
2. Terminate active user sessions on the affected host.
3. Block malicious source IP addresses at the perimeter/firewall.

### Step 4: Eradication & Recovery
1. Reset the compromised user credentials with a strong, complex passphrase.
2. Scan the host endpoint with Sysmon and endpoint telemetry to ensure no persistence mechanisms (scheduled tasks, run keys) were planted.
3. Restore the account and monitor for 24-48 hours.

### Step 5: Post-Incident Review
Document all findings, timeline, and remediation actions in the official Incident Report.
