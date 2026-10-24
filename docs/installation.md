# SOC Home Lab: Installation and Configuration Guide

This guide documents the installation, configuration, and verification steps for all tools in the SOC home lab.

---

## 1. Prerequisites and System Assessment
* **Host OS:** Windows 11 Home Single Language (64-bit)
* **RAM:** 16 GB DDR4/DDR5
* **Admin Privileges:** Required for driver and service installation.

---

## 2. Directory Structure Initialization
The repository is structured under `D:\soc-home-lab\` with isolated directories:
```text
D:\soc-home-lab\
├── docs/                   # Architecture, installation, and detection docs
├── splunk/
│   ├── searches/           # SPL queries for detection engineering
│   ├── dashboards/         # XML/JSON definitions for SOC dashboards
│   └── alerts/             # Alert threshold configurations
├── python/
│   ├── sample_logs/        # Sanitized sample event logs
│   ├── tests/              # Unit tests for log parsing
│   └── log_analyzer.py     # Log summarizer automation script
├── evidence/
│   ├── screenshots/        # Verified lab screenshots
│   └── sample_outputs/     # Raw command and query outputs
├── reports/                # Incident reports and templates
├── tools/                  # Sysmon binaries and configuration profiles
├── .gitignore
├── LICENSE
└── README.md
```

---

## 3. Microsoft Sysmon Installation
Sysmon is installed as a Windows kernel driver and service using SwiftOnSecurity's optimized configuration profile (`sysmonconfig.xml`).

### Steps:
1. Sysmon binary downloaded from Microsoft Sysinternals (`Sysmon64.exe`).
2. Configuration file downloaded from SwiftOnSecurity (`sysmonconfig-export.xml`).
3. Installed with elevated privileges:
   ```powershell
   D:\soc-home-lab\tools\sysmon\Sysmon64.exe -i D:\soc-home-lab\tools\sysmonconfig.xml -accepteula
   ```
4. Verification:
   ```powershell
   Get-Service -Name Sysmon64
   Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" -MaxEvents 5
   ```

---

## 4. Splunk Enterprise Installation (Pending)
* Status: In Progress
* Configuration: Local instance indexing Windows Security and Sysmon logs.
