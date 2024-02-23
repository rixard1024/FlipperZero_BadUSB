############################################################################################################################################################
# Title:          WiFi Grabber
# Author:         Rick (LordCodigo) Alvarez & Jose Espitia (Github: https://github.com/JoseEspitia)
# Description:    
#                 EN: Script for changin the desktop wallpaper (Prank)
#                 ES: Script para cambiar el fondo de escritorio (Broma)
# Target:         Device: Flipper Zero / Target platform: Windows
# Thanks to:      Jose Espitia for his post in https://www.joseespitia.com/2017/09/15/set-wallpaper-powershell-function/
############################################################################################################################################################

# Arguments
$uri_img = '<your_image_url_here>'                  # $args[0]     # Url for image [String]
$wait = 3               # $args[1]                  # Wait in seconds [Digit]
$style = 'Tile'         # $args[2]                  # Style: Fill, Fit, Stretch, Tile, Center, Span


Function Set-WallPaper {
 
<#
 
    .SYNOPSIS
    Applies a specified wallpaper to the current user's desktop
    
    .PARAMETER Image
    Provide the exact path to the image
 
    .PARAMETER Style
    Provide wallpaper style (Example: Fill, Fit, Stretch, Tile, Center, or Span)
  
    .EXAMPLE
    Set-WallPaper -Image "C:\Wallpaper\Default.jpg"
    Set-WallPaper -Image "C:\Wallpaper\Background.jpg" -Style Fit
  
#>
 
param (
    [parameter(Mandatory=$True)]
    # Provide path to image
    [string]$Image,
    # Provide wallpaper style that you would like applied
    [parameter(Mandatory=$False)]
    [ValidateSet('Fill', 'Fit', 'Stretch', 'Tile', 'Center', 'Span')]
    [string]$Style
)
 
$WallpaperStyle = Switch ($Style) {
  
    "Fill" {"10"}
    "Fit" {"6"}
    "Stretch" {"2"}
    "Tile" {"0"}
    "Center" {"0"}
    "Span" {"22"}
  
}
 
If($Style -eq "Tile") {
 
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -PropertyType String -Value $WallpaperStyle -Force
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -PropertyType String -Value 1 -Force
 
}
Else {
 
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -PropertyType String -Value $WallpaperStyle -Force
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -PropertyType String -Value 0 -Force
 
}
 
Add-Type -TypeDefinition @" 
using System; 
using System.Runtime.InteropServices;
  
public class Params
{ 
    [DllImport("User32.dll",CharSet=CharSet.Unicode)] 
    public static extern int SystemParametersInfo (Int32 uAction, 
                                                   Int32 uParam, 
                                                   String lpvParam, 
                                                   Int32 fuWinIni);
}
"@ 
  
    $SPI_SETDESKWALLPAPER = 0x0014
    $UpdateIniFile = 0x01
    $SendChangeEvent = 0x02
  
    $fWinIni = $UpdateIniFile -bor $SendChangeEvent
  
    $ret = [Params]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $Image, $fWinIni)
}


wget -Uri $uri_img -OutFile "C:\temp\wallpaper.jpg"
Start-Sleep -Seconds $wait # Wait  seconds

# + Surprise
# $shell = New-Object -ComObject "Shell.Application"
# $shell.MinimizeAll()

# + Surprise
# start-sleep -Seconds 1
# $Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
# Set-ItemProperty -Path $Path -Name "HideIcons" -Value 1
# Get-Process "explorer"| Stop-Process

start-sleep -Seconds 1
Set-WallPaper -Image "C:\temp\wallpaper.jpg" -Style $style

del "C:\temp\wallpaper.jpg"

# + Surprise
# Add-Type -AssemblyName PresentationFramework
# [System.Windows.MessageBox]::Show(MessageBody,Title,ButtonType,Image)
# 1..10 | % { 
#    [System.Windows.MessageBox]::Show("You have been hacked" + ("!" * $_),"H4ck3d!","OK","Stop")
#    start-sleep -Seconds 1
# }

# How call this ps1 file (just execute):
# .\Set-WallPaper.ps1