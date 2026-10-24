# Windows Event Log & Sysmon Telemetry Collection

## 1. Overview
This document details the event log channels, Event IDs, and audit policies monitored in the SOC Home Lab.

---

## 2. Ingested Channels

### Channel 1: `Security` (Windows Security Auditing)
* **Event ID 4624:** Successful Logon
  * Monitors user authentications, logon types (e.g., Type 2 Interactive, Type 3 Network, Type 10 RemoteInteractive).
* **Event ID 4625:** Failed Logon
  * Monitors authentication failures (wrong password, unknown username, disabled account). Critical for detecting brute force or password spraying.
* **Event ID 4740:** Account Lockout
  * Triggered when an account exceeds the maximum failed login threshold.
* **Event ID 4720:** User Account Created
  * Monitored for rogue local account creation and persistence.

### Channel 2: `Microsoft-Windows-Sysmon/Operational`
* **Event ID 1:** Process Creation
  * Deep visibility into process execution including `CommandLine`, `ParentCommandLine`, `User`, `Hashes` (SHA256), and `ParentImage`.
* **Event ID 3:** Network Connection
  * Telemetry for TCP/UDP outbound connections originating from processes.
* **Event ID 7:** Image Loaded
  * DLL loading events to monitor potential DLL injection or hijacking.
* **Event ID 11:** File Create
  * Detection of files written to critical directories (`C:\Windows\Temp\`, AppData).
* **Event ID 22:** DNS Query
  * Outbound domain lookups initiated by host processes.

---

## 3. Splunk Ingestion Mapping
* **Splunk Index:** `endpoint`
* **Sourcetypes:**
  * `WinEventLog:Security`
  * `WinEventLog:Microsoft-Windows-Sysmon/Operational`
