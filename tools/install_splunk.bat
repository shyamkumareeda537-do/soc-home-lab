@echo off
echo =======================================================
echo   Installing Splunk Enterprise (SOC Home Lab)
echo   Please wait 2-3 minutes while files are unpacked...
echo =======================================================
msiexec.exe /i "D:\soc-home-lab\tools\splunk.msi" AGREETOLICENSE=Yes SPLUNKUSERNAME=admin SPLUNKPASSWORD=LabPassword123! LAUNCHSPLUNK=1 /qb /l*v "D:\soc-home-lab\tools\splunk_install.log"
echo.
echo =======================================================
echo   Splunk Enterprise Installation Complete!
echo   You can now access Splunk Web at: http://localhost:8000
echo =======================================================
pause
