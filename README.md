# SOC Home Lab: Security Monitoring, Threat Detection, and Incident Investigation Using Splunk

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform: Windows 11](https://img.shields.io/badge/Platform-Windows%2011-0078D6.svg)](https://microsoft.com)
[![SIEM: Splunk Enterprise](https://img.shields.io/badge/SIEM-Splunk%20Enterprise-black.svg)](https://splunk.com)
[![Telemetry: Microsoft Sysmon](https://img.shields.io/badge/Telemetry-Sysmon%20v15-red.svg)](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon)

A practical, hands-on Security Operations Center (SOC) home lab demonstrating end-to-end telemetry ingestion, threat detection engineering, and incident investigation on a Windows endpoint using **Splunk Enterprise**, **Microsoft Sysmon**, and the **MITRE ATT&CK Framework**.

---

## 1. Project Overview & Problem Statement

Modern enterprise environments face continuous credential-based attacks, brute-force attempts, and unauthorized process execution. A core competency of a SOC Analyst is the ability to:
1. Ingest low-level operating system telemetry.
2. Filter background noise from genuine threats.
3. Formulate Search Processing Language (SPL) detection rules.
4. Triage alerts and reconstruct forensic attack timelines.

This project implements a fully functional local SOC pipeline simulating realistic threat scenarios and mapping findings to industry-standard frameworks.

---

## 2. Architecture & Data Flow

```
+-------------------------------------------------------------------------+
|                         WINDOWS 11 ENDPOINT                             |
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
                                       | Local Event Log Ingestion (WinEventLog)
                                       v
+-------------------------------------------------------------------------+
|                         SPLUNK ENTERPRISE CORE                          |
|                                                                         |
|  +-------------------------------------------------------------------+  |
|  |                    Data Ingestion / Parsing                       |  |
|  |       Source: WinEventLog:Security, WinEventLog:Sysmon            |  |
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
|  |  - SPL Correlation Searches (Brute Force, Lockouts, Sysmon Proc)  |  |
|  |  - MITRE ATT&CK Mapping (T1110, T1078, T1059.001)                 |  |
|  +------------------+--------------------------------+---------------+  |
|                     |                                |                  |
|                     v                                v                  |
|     +-------------------------------+   +------------------------+      |
|     |     Real-Time Alerting        |   |    SOC Dashboard       |      |
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

## 3. Technologies Used

* **SIEM:** Splunk Enterprise 9.2.x (Local instance on `localhost:8000`)
* **Operating System:** Windows 11 Home Single Language (64-bit)
* **Telemetry Sensor:** Microsoft Sysmon v15.22 with SwiftOnSecurity configuration
* **Log Subsystem:** Windows Event Viewer (`eventvwr.msc`), Security Channel
* **Scripting & Automation:** Python 3.13, PowerShell 5.1 / 7
* **Threat Intelligence:** VirusTotal API / Web Intelligence
* **Version Control:** Git & GitHub

---

## 4. System Requirements

* **RAM:** Minimum 8 GB (Lab running on 16 GB DDR4/DDR5)
* **Disk Space:** ~5 GB free disk space for Splunk indexing and event logs
* **Privileges:** Administrator access on Windows host

---

## 5. Implementation Status

| Module | Description | Status | Verification |
| :--- | :--- | :--- | :--- |
| **Module 1** | Environment Setup (Sysmon & Splunk Enterprise) | **Verified** | `Sysmon64` and `splunkd` services actively running |
| **Module 2** | Windows Security & Sysmon Telemetry Verification | **Verified** | Verified Event ID 1 & Windows Security events |
| **Module 3** | Splunk Data Inputs & `endpoint` Index Configuration | In Progress | Configuring local inputs |
| **Module 4** | Detection Engineering (SPL Queries & MITRE Mapping) | Pending | Scheduled next |
| **Module 5** | Controlled Security Event Generation & Testing | Pending | Scheduled next |
| **Module 6** | Interactive SOC Dashboard Creation | Pending | Scheduled next |
| **Module 7** | Simulated Incident Triage & Investigation | Pending | Scheduled next |
| **Module 8** | IOC Investigation & VirusTotal Intelligence | Pending | Scheduled next |
| **Module 9** | Incident Response Reporting | Pending | Scheduled next |
| **Module 10** | Python Log Automation & Final Validation | Pending | Scheduled next |

---

## 6. Directory Structure

```text
soc-home-lab/
├── docs/                   # Technical documentation
│   ├── architecture.md     # Pipeline and communication architecture
│   ├── installation.md     # Setup and verification manual
│   ├── log-collection.md   # Event log sources and audit policies
│   ├── detection-rules.md  # SPL threat detection rules
│   └── incident-response.md# Incident response playbook
├── splunk/                 # Splunk artifacts
│   ├── searches/           # Saved SPL queries
│   ├── dashboards/         # Dashboard XML definitions
│   └── alerts/             # Alert configurations
├── python/                 # Automation scripts
│   ├── log_analyzer.py     # Offline security log parser
│   ├── sample_logs/        # Sanitized sample event logs
│   └── tests/              # Unit tests
├── evidence/               # Verified evidence
│   ├── screenshots/        # Verified lab screenshots
│   └── sample_outputs/     # Raw query and command outputs
├── reports/                # Formal documentation
│   └── incident-report-template.md
├── tools/                  # Installation configurations
│   ├── install_splunk.bat  # Automated Splunk installer script
│   └── sysmonconfig.xml    # SwiftOnSecurity Sysmon profile
├── .gitignore              # Git exclusion rules
├── LICENSE                 # MIT License
└── README.md
```

---

## 7. Ethical and Legal Considerations

All activities within this project were conducted on an isolated, authorized local home lab workstation owned and operated by the author. No unauthorized attacks, network flooding, credential theft, or third-party system interactions were conducted. All telemetry and sample logs used for demonstration are sanitized to protect privacy and confidentiality.
