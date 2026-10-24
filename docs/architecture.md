# SOC Home Lab: Architecture & Data Flow

## 1. Overview
The SOC Home Lab is designed to simulate a realistic Security Operations Center data pipeline on a local Windows workstation. It captures endpoint activity, indexes it inside Splunk Enterprise, and applies Search Processing Language (SPL) detection rules mapped to the MITRE ATT&CK framework.

---

## 2. Architecture Diagram

```
+-------------------------------------------------------------------------+
|                         WINDOWS ENDPOINT                                |
|                                                                         |
|  +---------------------------+       +-------------------------------+  |
|  | Windows Security Auditing |       |      Microsoft Sysmon         |  |
|  |  - Event ID 4624 (Logon)  |       |  - Event ID 1 (Process Create)|  |
|  |  - Event ID 4625 (Failed) |       |  - Event ID 3 (Network Conn)  |  |
|  |  - Event ID 4740 (Lockout)|       |  - Event ID 11 (File Create)  |  |
|  +-------------+-------------+       +---------------+---------------+  |
|                |                                     |                  |
|                v                                     v                  |
|  +-------------------------------------------------------------------+  |
|  |              Windows Event Log Subsystem (Channel Bus)            |  |
|  +-----------------------------------+-------------------------------+  |
+--------------------------------------|----------------------------------+
                                       |
                                       | Local Event Log Ingestion (inputs.conf / WinEventLog)
                                       v
+-------------------------------------------------------------------------+
|                           SPLUNK SIEM CORE                              |
|                                                                         |
|  +-------------------------------------------------------------------+  |
|  |                    Data Ingestion / Parsing                       |  |
|  |       Source: WinEventLog:Security, WinEventLog:Microsoft-        |  |
|  |               Windows-Sysmon/Operational                          |  |
|  +-----------------------------------+-------------------------------+  |
|                                      |                                  |
|                                      v                                  |
|  +-------------------------------------------------------------------+  |
|  |                     Indexing & Storage (index=endpoint)           |  |
|  +-----------------------------------+-------------------------------+  |
|                                      |                                  |
|                                      v                                  |
|  +-------------------------------------------------------------------+  |
|  |                       Detection Engine                            |  |
|  |  - SPL Correlation Searches (Failed Logins, Lockouts, Sysmon)     |  |
|  |  - MITRE ATT&CK Mapping (T1078, T1110, T1059.001)                 |  |
|  +------------------+--------------------------------+---------------+  |
|                     |                                |                  |
|                     v                                v                  |
|     +-------------------------------+   +------------------------+      |
|     |     Real-Time Alerting        |   |    SOC SOC Dashboard   |      |
|     +---------------+---------------+   +------------+-----------+      |
+---------------------|--------------------------------|------------------+
                      |                                |
                      v                                v
+-------------------------------------------------------------------------+
|                  SOC ANALYST / INCIDENT RESPONSE                        |
|                                                                         |
|  - Threat Triage & Event Timeline Reconstruction                        |
|  - IOC Reputation Lookup (VirusTotal API / Manual Analysis)             |
|  - Incident Documentation & Containment Recommendations                 |
+-------------------------------------------------------------------------+
```

---

## 3. Telemetry Channels & Key Event IDs

| Data Source | Channel / Log Name | Event ID | Description | Primary Use Case |
| :--- | :--- | :--- | :--- | :--- |
| **Windows Security** | `Security` | **4624** | An account was successfully logged on | Baseline user activity, logon type analysis |
| **Windows Security** | `Security` | **4625** | An account failed to log on | Brute-force & credential-stuffing detection |
| **Windows Security** | `Security` | **4740** | A user account was locked out | Repeated failure impact assessment |
| **Windows Security** | `Security` | **4720** | A user account was created | Unauthorized persistence detection |
| **Microsoft Sysmon** | `Microsoft-Windows-Sysmon/Operational` | **1** | Process creation (Command line, parent, hashes) | Suspicious command & process execution |
| **Microsoft Sysmon** | `Microsoft-Windows-Sysmon/Operational` | **3** | Network connection detected | Command and Control (C2) detection |
| **Microsoft Sysmon** | `Microsoft-Windows-Sysmon/Operational` | **7** | Image loaded (DLL loading) | DLL injection / sideloading monitoring |
| **Microsoft Sysmon** | `Microsoft-Windows-Sysmon/Operational` | **11** | File create | File integrity / dropped payload tracking |
| **Microsoft Sysmon** | `Microsoft-Windows-Sysmon/Operational` | **22** | DNSEvent (DNS query initiated) | Domain name resolution monitoring |

---

## 4. Component Communication Details

1. **Endpoint Generation:** The Windows OS kernel and the Sysmon filter driver (`SysmonDrv.sys`) write events into their respective event log channels.
2. **Splunk Ingestion:** Splunk's event-log input reader accesses the Windows Event Log API to consume records in near real-time without locking the underlying log files.
3. **Indexing:** Raw records are timestamped, indexed into the `endpoint` index, and enriched with parsed fields (such as `EventCode`, `TargetUserName`, `CommandLine`, and `ParentImage`).
4. **Analytics & Dashboards:** SOC analysts execute SPL queries against the index. Dashboards poll these queries periodically to render metrics, charts, and alert status panels.
