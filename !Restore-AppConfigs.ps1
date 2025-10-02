#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Windows Application Configuration Restore Script
.DESCRIPTION
    Restores application configurations from backup to their respective system locations.
.NOTES
    This script must be run as Administrator in Windows Terminal.
#>

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Red
    Write-Host "  ADMINISTRATOR PRIVILEGES REQUIRED" -ForegroundColor Yellow
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Red
    Write-Host ""
    Write-Host "  This script requires administrator privileges to execute." -ForegroundColor White
    Write-Host "  Please restart Windows Terminal as Administrator and try again." -ForegroundColor White
    Write-Host ""
    Write-Host "  To run as Administrator:" -ForegroundColor Cyan
    Write-Host "  1. Right-click on Windows Terminal" -ForegroundColor Gray
    Write-Host "  2. Select 'Run as Administrator'" -ForegroundColor Gray
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Red
    Write-Host ""
    Write-Host "Press any key to exit..." -ForegroundColor DarkGray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

# Script Header
Clear-Host
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  WINDOWS APPLICATION CONFIGURATION RESTORE" -ForegroundColor White
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Set current path
$CurrentPath = $PSScriptRoot
Write-Host "[INFO] Current Path: $CurrentPath" -ForegroundColor Gray
Write-Host ""

# Define applications to terminate
$applicationsToKill = @(
    "pwsh",
    "PowerToys",
    "PowerToys.PowerLauncher",
    "PowerToys.Settings",
    "Espanso",
    "JPEGView",
    "JDownloader",
    "JDownloader2",
    "java",
    "Typora"
)

# Terminate running applications
Write-Host "───────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host " STEP 1: Terminating Running Applications" -ForegroundColor Yellow
Write-Host "───────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host ""

foreach ($app in $applicationsToKill) {
    $processes = Get-Process -Name $app -ErrorAction SilentlyContinue
    if ($processes) {
        try {
            $processes | Stop-Process -Force -ErrorAction Stop
            Write-Host "[✓] Terminated: $app" -ForegroundColor Green
        }
        catch {
            Write-Host "[✗] Failed to terminate: $app" -ForegroundColor Red
        }
    }
    else {
        Write-Host "[–] Not running: $app" -ForegroundColor DarkGray
    }
}

Write-Host ""
Start-Sleep -Seconds 2

# Define restoration paths
$restorePaths = @(
    @{
        Source = "$CurrentPath\Documents\*"
        Destination = "$HOME\Documents\"
        Description = "Windows PowerShell 7, PowerToys, PowerToys (NewPlus)"
    },
    @{
        Source = "$CurrentPath\AppData\*"
        Destination = "$env:APPDATA"
        Description = "Espanso, JPEGView"
    },
    @{
        Source = "$CurrentPath\LocalAppData\*"
        Destination = "$env:LOCALAPPDATA"
        Description = "JDownloader (Dark Theme)"
    },
    @{
        Source = "$CurrentPath\ProgramFiles\*"
        Destination = "$env:PROGRAMFILES"
        Description = "Typora Themes"
    }
)

# Restore configurations
Write-Host "───────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host " STEP 2: Restoring Application Configurations" -ForegroundColor Yellow
Write-Host "───────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host ""

$successCount = 0
$totalCount = $restorePaths.Count

foreach ($path in $restorePaths) {
    Write-Host "[→] Restoring: $($path.Description)" -ForegroundColor Cyan
    
    if (Test-Path -Path $path.Source.TrimEnd('\*')) {
        try {
            Copy-Item -Path $path.Source -Destination $path.Destination -Recurse -Force -ErrorAction Stop
            Write-Host "[✓] Success: Configuration files copied to $($path.Destination)" -ForegroundColor Green
            $successCount++
        }
        catch {
            Write-Host "[✗] Error: Failed to copy files - $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    else {
        Write-Host "[!] Warning: Source path not found - $($path.Source)" -ForegroundColor Yellow
    }
    Write-Host ""
}

# Final message
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  RESTORATION COMPLETE" -ForegroundColor White
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

if ($successCount -eq $totalCount) {
    Write-Host "  Windows application configurations have been successfully" -ForegroundColor Green
    Write-Host "  restored to their respective system locations." -ForegroundColor Green
    Write-Host ""
    Write-Host "  All $successCount of $totalCount configuration sets were restored without errors." -ForegroundColor White
}
else {
    Write-Host "  Restoration completed with warnings." -ForegroundColor Yellow
    Write-Host "  $successCount of $totalCount configuration sets were restored." -ForegroundColor White
    Write-Host ""
    Write-Host "  Please review the messages above for any issues." -ForegroundColor Gray
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor DarkGray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")