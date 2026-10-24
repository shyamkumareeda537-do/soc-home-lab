# Security Incident Report Template

| Field | Details |
| :--- | :--- |
| **Incident ID** | INC-2026-001 |
| **Incident Title** | Suspicious Repeated Authentication Failures Followed by Successful Logon |
| **Date & Time (UTC)**| YYYY-MM-DD HH:MM:SS |
| **Severity Level** | Low / Medium / High / Critical |
| **Status** | Open / Under Investigation / Contained / Closed |
| **Lead Analyst** | Security Analyst (SOC Tier 1 / Tier 2) |

---

## 1. Executive Summary
Brief non-technical overview of the incident, impact on business operations, and primary actions taken.

---

## 2. Affected Assets & Accounts
* **Affected Hostname / IP:**
* **Target Account(s):**
* **Attacker Source IP / Machine:**
* **Detection Mechanism:** Splunk SPL Correlation Rule / Sysmon Telemetry

---

## 3. Incident Timeline
| Timestamp | Event Description | Source / Log Channel | Event ID |
| :--- | :--- | :--- | :--- |
| `HH:MM:SS` | Initial failed logon attempt | WinEventLog:Security | 4625 |
| `HH:MM:SS` | Consecutive failed logon attempts | WinEventLog:Security | 4625 |
| `HH:MM:SS` | Successful logon | WinEventLog:Security | 4624 |
| `HH:MM:SS` | Suspicious command execution | WinEventLog:Sysmon | 1 |

---

## 4. Evidence & SPL Queries Used
```spl
index=endpoint (EventCode=4625 OR EventCode=4624) TargetUserName="testuser"
| table _time, EventCode, TargetUserName, IpAddress, WorkstationName
```

---

## 5. MITRE ATT&CK Mapping
* **Tactic:** Credential Access (TA0006) / Initial Access (TA0001)
* **Technique:** T1110 - Brute Force / T1078 - Valid Accounts

---

## 6. Root Cause & False Positive Assessment
Analysis of whether this activity was an unauthorized penetration attempt or user error / misconfigured script.

---

## 7. Containment, Eradication & Recovery
* Actions taken to prevent further compromise:
* Recovery procedures applied:

---

## 8. Lessons Learned & Recommendations
Recommendations to improve detection fidelity, reduce attack surface, and adjust audit policies.
