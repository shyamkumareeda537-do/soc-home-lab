# Threat Detection Rules & MITRE ATT&CK Mapping

This document details the threat detection rules implemented in Splunk using Search Processing Language (SPL).

---

## Detection 1: Repeated Failed Logins (Brute Force / Password Spraying)
* **MITRE ATT&CK:** [T1110 - Brute Force](https://attack.mitre.org/techniques/T1110/)
* **Objective:** Detect multiple failed login attempts against a single user account within a short timeframe.
* **SPL Query:**
  ```spl
  index=endpoint (sourcetype="WinEventLog:Security" EventCode=4625) OR (EventCode=4625)
  | stats count, values(Workstation_Name) as Source_Workstation, values(IpAddress) as Source_IP by TargetUserName, _time span=5m
  | where count >= 3
  | sort - count
  ```

---

## Detection 2: Successful Login After Multiple Failed Logins
* **MITRE ATT&CK:** [T1078 - Valid Accounts](https://attack.mitre.org/techniques/T1078/)
* **Objective:** Identify when an account experiences consecutive login failures followed immediately by a successful authentication, indicating a potential brute-force compromise.
* **SPL Query:**
  ```spl
  index=endpoint (EventCode=4625 OR EventCode=4624)
  | eval Status=if(EventCode==4625, "Failure", "Success")
  | transaction TargetUserName maxspan=15m startswith=(Status="Failure") endswith=(Status="Success")
  | eval FailedAttempts=mvcount(mvfilter(Status=="Failure"))
  | where FailedAttempts >= 2
  | table _time, TargetUserName, FailedAttempts, duration
  ```

---

## Detection 3: User Account Lockout
* **MITRE ATT&CK:** [T1110.001 - Password Guessing](https://attack.mitre.org/techniques/T1110/001/)
* **Objective:** Detect when an account exceeds failed attempt thresholds resulting in an account lockout.
* **SPL Query:**
  ```spl
  index=endpoint EventCode=4740
  | table _time, TargetUserName, Caller_Computer_Name, SubjectUserName
  ```

---

## Detection 4: Suspicious PowerShell Execution with Encoded / Bypass Flags
* **MITRE ATT&CK:** [T1059.001 - Command and Scripting Interpreter: PowerShell](https://attack.mitre.org/techniques/T1059/001/)
* **Objective:** Detect PowerShell executions employing evasion arguments (`-ExecutionPolicy Bypass`, `-enc`, `-NoProfile`, `DownloadString`).
* **SPL Query:**
  ```spl
  index=endpoint sourcetype="WinEventLog:Microsoft-Windows-Sysmon/Operational" EventCode=1
  | eval process=lower(CommandLine)
  | search process="*powershell*" AND (process="*-enc*" OR process="*bypass*" OR process="*downloadstring*" OR process="*hidden*")
  | table _time, User, ParentImage, Image, CommandLine
  ```

---

## Detection 5: Unusual Parent-Child Process Relationships
* **MITRE ATT&CK:** [T1059 - Command and Scripting Interpreter](https://attack.mitre.org/techniques/T1059/)
* **Objective:** Detect command interpreters (`cmd.exe`, `powershell.exe`) spawned by abnormal parent processes like Office applications or web browsers.
* **SPL Query:**
  ```spl
  index=endpoint sourcetype="WinEventLog:Microsoft-Windows-Sysmon/Operational" EventCode=1
  | where match(ParentImage, "(?i)(winword|excel|powerpnt|chrome|msedge)\.exe") AND match(Image, "(?i)(cmd|powershell|wscript|cscript)\.exe")
  | table _time, Computer, ParentImage, Image, CommandLine
  ```
