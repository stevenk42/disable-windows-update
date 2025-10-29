@echo off
title Operation Update Oblivion
color 0c
echo =====================================================
echo ==  INITIATING TOTAL UPDATE SHUTDOWN PROTOCOL...  ==
echo =====================================================

:: Stop Update Services
echo Stopping update-related services...
net stop wuauserv /y
net stop bits /y
net stop dosvc /y
net stop usosvc /y
net stop WaaSMedicSvc /y
net stop wscsvc /y
net stop WinDefend /y
net stop DeliveryOptimization /y

:: Disable Them at Startup
echo Disabling services permanently...
sc config wuauserv start= disabled
sc config bits start= disabled
sc config dosvc start= disabled
sc config usosvc start= disabled
sc config WaaSMedicSvc start= disabled
sc config wscsvc start= disabled
sc config WinDefend start= disabled
sc config DeliveryOptimization start= disabled

:: Kill Windows Update Scheduled Tasks
echo Removing scheduled update tasks...
schtasks /Change /TN "Microsoft\Windows\WindowsUpdate\Scheduled Start" /Disable
schtasks /Change /TN "Microsoft\Windows\WindowsUpdate\Automatic App Update" /Disable
schtasks /Change /TN "Microsoft\Windows\UpdateOrchestrator\*" /Disable
schtasks /Change /TN "Microsoft\Windows\InstallService\*" /Disable

:: Firewall Cleanup & Block
echo Purging old update rules and creating new blocks...
netsh advfirewall firewall delete rule name="*Windows Update*"
netsh advfirewall firewall add rule name="Block Windows Update" dir=out action=block remoteip=13.107.4.50,13.107.5.50,52.184.250.0/24 enable=yes

:: Hosts File Reinforcement
echo Updating hosts file...
set HOSTS=%SystemRoot%\System32\drivers\etc\hosts
echo 0.0.0.0 windowsupdate.microsoft.com>>%HOSTS%
echo 0.0.0.0 update.microsoft.com>>%HOSTS%
echo 0.0.0.0 windowsupdate.com>>%HOSTS%
echo 0.0.0.0 download.windowsupdate.com>>%HOSTS%
echo 0.0.0.0 wustat.windows.com>>%HOSTS%
echo 0.0.0.0 ntservicepack.microsoft.com>>%HOSTS%
echo 0.0.0.0 update.microsoft.com.nsatc.net>>%HOSTS%

ipconfig /flushdns

echo =====================================================
echo ==  WINDOWS UPDATE HAS BEEN TERMINATED. FOREVER.  ==
echo =====================================================
pause
