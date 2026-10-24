@echo off
echo ========================================================
echo   Configuring Splunk Inputs and Indexes for SOC Lab
echo ========================================================

set SPLUNK_HOME=C:\Program Files\Splunk
if not exist "%SPLUNK_HOME%" (
    echo Error: Splunk installation not found at %SPLUNK_HOME%
    pause
    exit /b 1
)

mkdir "%SPLUNK_HOME%\etc\apps\soc_lab_inputs\local" 2>nul

echo [1/3] Writing inputs.conf for Windows Security and Sysmon...
(
echo [WinEventLog://Security]
echo disabled = 0
echo index = endpoint
echo.
echo [WinEventLog://Microsoft-Windows-Sysmon/Operational]
echo disabled = 0
echo index = endpoint
echo renderXml = 1
) > "%SPLUNK_HOME%\etc\apps\soc_lab_inputs\local\inputs.conf"

echo [2/3] Writing indexes.conf for 'endpoint' index...
(
echo [endpoint]
echo homePath   = $SPLUNK_DB/endpoint/db
echo coldPath   = $SPLUNK_DB/endpoint/colddb
echo thawedPath = $SPLUNK_DB/endpoint/thaweddb
) > "%SPLUNK_HOME%\etc\apps\soc_lab_inputs\local\indexes.conf"

echo [3/3] Restarting Splunk Service to load new configurations...
powershell -NoProfile -Command "Restart-Service -Name splunkd -Force"

echo ========================================================
echo   Splunk SOC Lab Inputs Configured Successfully!
echo   Index: endpoint
echo   Channels: Security + Sysmon/Operational
echo ========================================================
pause
