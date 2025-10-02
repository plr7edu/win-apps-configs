#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Windows Application Configuration Backup Script
.DESCRIPTION
    Backs up application configurations from system locations to organized backup folders.
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
Write-Host "  WINDOWS APPLICATION CONFIGURATION BACKUP" -ForegroundColor White
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Set current path
$CurrentPath = $PSScriptRoot
Write-Host "[INFO] Backup Location: $CurrentPath" -ForegroundColor Gray
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

# Define backup paths for folders (full backup)
$backupPaths = @(
    @{
        Source = "$HOME\Documents\PowerShell"
        Destination = "$CurrentPath\Documents\PowerShell"
        Description = "Windows PowerShell 7"
        Type = "Folder"
    },
    @{
        Source = "$HOME\Documents\PowerToys"
        Destination = "$CurrentPath\Documents\PowerToys"
        Description = "PowerToys, PowerToys (NewPlus)"
        Type = "Folder"
    },
    @{
        Source = "$env:APPDATA\espanso"
        Destination = "$CurrentPath\AppData\espanso"
        Description = "Espanso"
        Type = "Folder"
    },
    @{
        Source = "$env:APPDATA\JPEGView"
        Destination = "$CurrentPath\AppData\JPEGView"
        Description = "JPEGView"
        Type = "Folder"
    },
    @{
        Source = "$env:APPDATA\GPSoftware"
        Destination = "$CurrentPath\AppData\GPSoftware"
        Description = "Directory Opus"
        Type = "Folder"
    },
    @{
        Source = "$env:LOCALAPPDATA\JDownloader 2.0\cfg"
        Destination = "$CurrentPath\LocalAppData\JDownloader 2.0\cfg"
        Description = "JDownloader 2 (Full Configuration)"
        Type = "Folder"
    }
)

# Define specific files to backup
$specificFiles = @(
    @{
        Source = "${env:PROGRAMFILES}\Typora\resources\style\themes\github-dark-default.css"
        Destination = "$CurrentPath\ProgramFiles\Typora\resources\style\themes\github-dark-default.css"
        Description = "Typora Theme (github-dark-default)"
    }
    @{
        Source = "${env:PROGRAMFILES}\Typora\resources\style\themes\github-dark-dimmed.css"
        Destination = "$CurrentPath\ProgramFiles\Typora\resources\style\themes\github-dark-dimmed.css"
        Description = "Typora Theme (github-dark-dimmed)"
    }
    @{
        Source = "${env:PROGRAMFILES}\Typora\resources\style\themes\github-dark-high-contrast.css"
        Destination = "$CurrentPath\ProgramFiles\Typora\resources\style\themes\github-dark-high-contrast.css"
        Description = "Typora Theme (github-dark-high-contrast)"
    }
)

# Define wildcard file backups
$wildcardFiles = @(
    @{
        SourcePattern = "$env:APPDATA\FileZilla\*.xml"
        DestinationFolder = "$CurrentPath\AppData\FileZilla"
        Description = "FileZilla (XML Configuration Files)"
    }
)

# Create backup directory structure
Write-Host "───────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host " STEP 2: Creating Backup Directory Structure" -ForegroundColor Yellow
Write-Host "───────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host ""

$backupFolders = @("Documents", "AppData", "LocalAppData", "ProgramFiles")
foreach ($folder in $backupFolders) {
    $folderPath = Join-Path -Path $CurrentPath -ChildPath $folder
    if (-not (Test-Path -Path $folderPath)) {
        try {
            New-Item -Path $folderPath -ItemType Directory -Force | Out-Null
            Write-Host "[✓] Created: $folder" -ForegroundColor Green
        }
        catch {
            Write-Host "[✗] Failed to create: $folder" -ForegroundColor Red
        }
    }
    else {
        Write-Host "[–] Already exists: $folder" -ForegroundColor DarkGray
    }
}

Write-Host ""
Start-Sleep -Seconds 1

# Backup configurations
Write-Host "───────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host " STEP 3: Backing Up Application Configurations" -ForegroundColor Yellow
Write-Host "───────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host ""

$successCount = 0
$totalCount = $backupPaths.Count + $specificFiles.Count + $wildcardFiles.Count

# Backup folders
foreach ($path in $backupPaths) {
    Write-Host "[→] Backing up: $($path.Description)" -ForegroundColor Cyan
    
    if (Test-Path -Path $path.Source) {
        try {
            # Ensure destination parent directory exists
            $destParent = Split-Path -Path $path.Destination -Parent
            if (-not (Test-Path -Path $destParent)) {
                New-Item -Path $destParent -ItemType Directory -Force | Out-Null
            }
            
            # Remove existing backup if it exists
            if (Test-Path -Path $path.Destination) {
                Remove-Item -Path $path.Destination -Recurse -Force -ErrorAction Stop
            }
            
            # Copy files
            Copy-Item -Path $path.Source -Destination $path.Destination -Recurse -Force -ErrorAction Stop
            Write-Host "[✓] Success: Configuration files backed up to $($path.Destination)" -ForegroundColor Green
            $successCount++
        }
        catch {
            Write-Host "[✗] Error: Failed to backup files - $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    else {
        Write-Host "[!] Warning: Source path not found - $($path.Source)" -ForegroundColor Yellow
    }
    Write-Host ""
}

# Backup specific files
foreach ($file in $specificFiles) {
    Write-Host "[→] Backing up: $($file.Description)" -ForegroundColor Cyan
    
    if (Test-Path -Path $file.Source) {
        try {
            # Ensure destination directory exists
            $destParent = Split-Path -Path $file.Destination -Parent
            if (-not (Test-Path -Path $destParent)) {
                New-Item -Path $destParent -ItemType Directory -Force | Out-Null
            }
            
            # Remove existing backup if it exists
            if (Test-Path -Path $file.Destination) {
                Remove-Item -Path $file.Destination -Force -ErrorAction Stop
            }
            
            # Copy file
            Copy-Item -Path $file.Source -Destination $file.Destination -Force -ErrorAction Stop
            Write-Host "[✓] Success: File backed up to $($file.Destination)" -ForegroundColor Green
            $successCount++
        }
        catch {
            Write-Host "[✗] Error: Failed to backup file - $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    else {
        Write-Host "[!] Warning: Source file not found - $($file.Source)" -ForegroundColor Yellow
    }
    Write-Host ""
}

# Backup wildcard files
foreach ($wildcard in $wildcardFiles) {
    Write-Host "[→] Backing up: $($wildcard.Description)" -ForegroundColor Cyan
    
    $matchedFiles = Get-ChildItem -Path $wildcard.SourcePattern -ErrorAction SilentlyContinue
    
    if ($matchedFiles) {
        try {
            # Ensure destination directory exists
            if (-not (Test-Path -Path $wildcard.DestinationFolder)) {
                New-Item -Path $wildcard.DestinationFolder -ItemType Directory -Force | Out-Null
            }
            
            # Remove existing backups in destination folder
            if (Test-Path -Path $wildcard.DestinationFolder) {
                Get-ChildItem -Path $wildcard.DestinationFolder -Filter "*.xml" | Remove-Item -Force -ErrorAction SilentlyContinue
            }
            
            # Copy all matched files
            $fileCount = 0
            foreach ($matchedFile in $matchedFiles) {
                Copy-Item -Path $matchedFile.FullName -Destination $wildcard.DestinationFolder -Force -ErrorAction Stop
                $fileCount++
            }
            
            Write-Host "[✓] Success: $fileCount file(s) backed up to $($wildcard.DestinationFolder)" -ForegroundColor Green
            $successCount++
        }
        catch {
            Write-Host "[✗] Error: Failed to backup files - $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    else {
        Write-Host "[!] Warning: No files found matching pattern - $($wildcard.SourcePattern)" -ForegroundColor Yellow
    }
    Write-Host ""
}

# Final message
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  BACKUP COMPLETE" -ForegroundColor White
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

if ($successCount -eq $totalCount) {
    Write-Host "  Windows application configurations have been successfully" -ForegroundColor Green
    Write-Host "  backed up to the current directory." -ForegroundColor Green
    Write-Host ""
    Write-Host "  All $successCount of $totalCount configuration sets were backed up without errors." -ForegroundColor White
}
else {
    Write-Host "  Backup completed with warnings." -ForegroundColor Yellow
    Write-Host "  $successCount of $totalCount configuration sets were backed up." -ForegroundColor White
    Write-Host ""
    Write-Host "  Please review the messages above for any issues." -ForegroundColor Gray
}

Write-Host ""
Write-Host "  Backup Location: $CurrentPath" -ForegroundColor Gray
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor DarkGray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")