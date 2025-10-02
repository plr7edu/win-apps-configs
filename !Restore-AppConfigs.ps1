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
Write-Host "[INFO] Restore Source: $CurrentPath" -ForegroundColor Gray
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
    "Typora",
    "dopus",
    "filezilla"
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

# Define folder restoration paths
$restoreFolders = @(
    @{
        Source = "$CurrentPath\Documents\PowerShell"
        Destination = "$HOME\Documents\PowerShell"
        Description = "Windows PowerShell 7"
    },
    @{
        Source = "$CurrentPath\Documents\PowerToys"
        Destination = "$HOME\Documents\PowerToys"
        Description = "PowerToys, PowerToys (NewPlus)"
    },
    @{
        Source = "$CurrentPath\AppData\espanso"
        Destination = "$env:APPDATA\espanso"
        Description = "Espanso"
    },
    @{
        Source = "$CurrentPath\AppData\JPEGView"
        Destination = "$env:APPDATA\JPEGView"
        Description = "JPEGView"
    },
    @{
        Source = "$CurrentPath\AppData\GPSoftware"
        Destination = "$env:APPDATA\GPSoftware"
        Description = "Directory Opus"
    },
    @{
        Source = "$CurrentPath\LocalAppData\JDownloader 2.0\cfg"
        Destination = "$env:LOCALAPPDATA\JDownloader 2.0\cfg"
        Description = "JDownloader 2 (Full Configuration)"
    }
)

# Define specific files to restore
$restoreFiles = @(
    @{
        Source = "$CurrentPath\ProgramFiles\Typora\resources\style\themes\github-dark-default.css"
        Destination = "${env:PROGRAMFILES}\Typora\resources\style\themes\github-dark-default.css"
        Description = "Typora Theme (github-dark-default)"
    }
    @{
        Source = "$CurrentPath\ProgramFiles\Typora\resources\style\themes\github-dark-dimmed.css"
        Destination = "${env:PROGRAMFILES}\Typora\resources\style\themes\github-dark-dimmed.css"
        Description = "Typora Theme (github-dark-dimmed)"
    }
    @{
        Source = "$CurrentPath\ProgramFiles\Typora\resources\style\themes\github-dark-high-contrast.css"
        Destination = "${env:PROGRAMFILES}\Typora\resources\style\themes\github-dark-high-contrast.css"
        Description = "Typora Theme (github-dark-high-contrast)"
    }
)

# Define wildcard file restores
$restoreWildcards = @(
    @{
        SourceFolder = "$CurrentPath\AppData\FileZilla"
        DestinationFolder = "$env:APPDATA\FileZilla"
        Pattern = "*.xml"
        Description = "FileZilla (XML Configuration Files)"
    }
)

# Restore configurations
Write-Host "───────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host " STEP 2: Restoring Application Configurations" -ForegroundColor Yellow
Write-Host "───────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host ""

$successCount = 0
$totalCount = $restoreFolders.Count + $restoreFiles.Count + $restoreWildcards.Count

# Restore folders
foreach ($folder in $restoreFolders) {
    Write-Host "[→] Restoring: $($folder.Description)" -ForegroundColor Cyan
    
    if (Test-Path -Path $folder.Source) {
        try {
            # Ensure destination parent directory exists
            $destParent = Split-Path -Path $folder.Destination -Parent
            if (-not (Test-Path -Path $destParent)) {
                New-Item -Path $destParent -ItemType Directory -Force | Out-Null
            }
            
            # Remove existing configuration if it exists
            if (Test-Path -Path $folder.Destination) {
                Remove-Item -Path $folder.Destination -Recurse -Force -ErrorAction Stop
            }
            
            # Copy files
            Copy-Item -Path $folder.Source -Destination $folder.Destination -Recurse -Force -ErrorAction Stop
            Write-Host "[✓] Success: Configuration files restored to $($folder.Destination)" -ForegroundColor Green
            $successCount++
        }
        catch {
            Write-Host "[✗] Error: Failed to restore files - $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    else {
        Write-Host "[!] Warning: Source path not found - $($folder.Source)" -ForegroundColor Yellow
    }
    Write-Host ""
}

# Restore specific files
foreach ($file in $restoreFiles) {
    Write-Host "[→] Restoring: $($file.Description)" -ForegroundColor Cyan
    
    if (Test-Path -Path $file.Source) {
        try {
            # Ensure destination directory exists
            $destParent = Split-Path -Path $file.Destination -Parent
            if (-not (Test-Path -Path $destParent)) {
                New-Item -Path $destParent -ItemType Directory -Force | Out-Null
            }
            
            # Remove existing file if it exists
            if (Test-Path -Path $file.Destination) {
                Remove-Item -Path $file.Destination -Force -ErrorAction Stop
            }
            
            # Copy file
            Copy-Item -Path $file.Source -Destination $file.Destination -Force -ErrorAction Stop
            Write-Host "[✓] Success: File restored to $($file.Destination)" -ForegroundColor Green
            $successCount++
        }
        catch {
            Write-Host "[✗] Error: Failed to restore file - $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    else {
        Write-Host "[!] Warning: Source file not found - $($file.Source)" -ForegroundColor Yellow
    }
    Write-Host ""
}

# Restore wildcard files
foreach ($wildcard in $restoreWildcards) {
    Write-Host "[→] Restoring: $($wildcard.Description)" -ForegroundColor Cyan
    
    $sourcePattern = Join-Path -Path $wildcard.SourceFolder -ChildPath $wildcard.Pattern
    $matchedFiles = Get-ChildItem -Path $sourcePattern -ErrorAction SilentlyContinue
    
    if ($matchedFiles) {
        try {
            # Ensure destination directory exists
            if (-not (Test-Path -Path $wildcard.DestinationFolder)) {
                New-Item -Path $wildcard.DestinationFolder -ItemType Directory -Force | Out-Null
            }
            
            # Copy all matched files
            $fileCount = 0
            foreach ($matchedFile in $matchedFiles) {
                $destPath = Join-Path -Path $wildcard.DestinationFolder -ChildPath $matchedFile.Name
                Copy-Item -Path $matchedFile.FullName -Destination $destPath -Force -ErrorAction Stop
                $fileCount++
            }
            
            Write-Host "[✓] Success: $fileCount file(s) restored to $($wildcard.DestinationFolder)" -ForegroundColor Green
            $successCount++
        }
        catch {
            Write-Host "[✗] Error: Failed to restore files - $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    else {
        Write-Host "[!] Warning: No files found matching pattern in $($wildcard.SourceFolder)" -ForegroundColor Yellow
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
Write-Host "  Restored from: $CurrentPath" -ForegroundColor Gray
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor DarkGray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")