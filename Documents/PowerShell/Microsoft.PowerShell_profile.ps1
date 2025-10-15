#░█▀█░█▀█░█░█░█▀▀░█▀▄░█▀▀░█░█░█▀▀░█░░░█░░░░░▀▀█░░░█▀█░█▀▄░█▀█░█▀▀░▀█▀░█░░░█▀▀
#░█▀▀░█░█░█▄█░█▀▀░█▀▄░▀▀█░█▀█░█▀▀░█░░░█░░░░░▄▀░░░░█▀▀░█▀▄░█░█░█▀▀░░█░░█░░░█▀▀
#░▀░░░▀▀▀░▀░▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀▀▀░░░▀░░░░░▀░░░▀░▀░▀▀▀░▀░░░▀▀▀░▀▀▀░▀▀▀
#

#$env:GIT_SSH = "C:\Program Files\OpenSSH\ssh.exe"

# Define path for tracking last execution time
$TimeFilePath = [Environment]::GetFolderPath("MyDocuments") + "\PowerShell\LastExecutionTime.txt"

# Allow override of time file path
if ($TimeFilePath_Override) {
    $TimeFilePath = $TimeFilePath_Override
}

# Write current timestamp to execution tracking file
function Write-LastExecutionTime {
    param([string]$Format = 'yyyy-MM-dd')
    $Dir = Split-Path -Parent $TimeFilePath
    if (-not (Test-Path $Dir)) {
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    }
    $Now = Get-Date -Format $Format
    Set-Content -Path $TimeFilePath -Value $Now -Encoding ASCII
}

# Read last execution timestamp from file
function Read-LastExecutionTime {
    if (Test-Path $TimeFilePath) {
        Get-Content -Path $TimeFilePath -Raw
    } else {
        Write-Host "Last execution time file not found: $TimeFilePath" -ForegroundColor Yellow
    }
}

# Install and import essential modules
if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
    Install-Module -Name Terminal-Icons -Scope CurrentUser -Force -SkipPublisherCheck
}
Import-Module -Name Terminal-Icons

# Import chocolatey profile if available
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}

# Check if running as administrator
$IsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# Customize prompt display
function prompt {
    if ($IsAdmin) { "[" + (Get-Location) + "] # " } else { "[" + (Get-Location) + "] $ " }
}

# Set window title with admin indicator
$AdminSuffix = if ($IsAdmin) { " [ADMIN]" } else { "" }
$Host.UI.RawUI.WindowTitle = "PowerShell {0}$AdminSuffix" -f $PSVersionTable.PSVersion.ToString()

# Test if command exists in path
function Test-CommandExists {
    param($Command)
    $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

# Configure default editor with override support
if ($EDITOR_Override) {
    $EDITOR = $EDITOR_Override
} else {
    $EDITOR = if (Test-CommandExists nvim) { 'nvim' }
        elseif (Test-CommandExists pvim) { 'pvim' }
        elseif (Test-CommandExists vim) { 'vim' }
        elseif (Test-CommandExists vi) { 'vi' }
        elseif (Test-CommandExists code) { 'code' }
        elseif (Test-CommandExists notepad++) { 'notepad++' }
        else { 'notepad' }
}
Set-Alias -Name vim -Value $EDITOR

# Edit current user profile
function Edit-Profile {
    vim $PROFILE.CurrentUserAllHosts
}
Set-Alias -Name ep -Value Edit-Profile

# Create empty file
function touch($File) { "" | Out-File $File -Encoding ASCII }

# Find files by name pattern
function ff($Name) {
    Get-ChildItem -Recurse -Filter "*${Name}*" -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Output $_.FullName
    }
}

# Get public ip address
function Get-PubIP { (Invoke-WebRequest https://ifconfig.me/ip).Content }
Set-Alias -Name ip -Value Get-PubIP

# Run command or shell as administrator
function admin {
    if ($args.Count -gt 0) {
        $ArgList = $args -join ' '
        Start-Process wt -Verb runAs -ArgumentList "pwsh.exe -NoExit -Command $ArgList"
    } else {
        Start-Process wt -Verb runAs
    }
}
Set-Alias -Name su -Value admin

# Display system uptime information
function uptime {
    try {
        if ($PSVersionTable.PSVersion.Major -eq 5) {
            $LastBoot = (Get-WmiObject win32_operatingsystem).LastBootUpTime
            $BootTime = [System.Management.ManagementDateTimeConverter]::ToDateTime($LastBoot)
        } else {
            $BootTime = (Get-Uptime -Since)
        }
        
        $Uptime = (Get-Date) - $BootTime
        Write-Host "System started on: $($BootTime.ToString('dddd, MMMM dd, yyyy HH:mm:ss'))" -ForegroundColor DarkGray
        Write-Host ("Uptime: {0} days, {1} hours, {2} minutes, {3} seconds" -f $Uptime.Days, $Uptime.Hours, $Uptime.Minutes, $Uptime.Seconds) -ForegroundColor Blue
    }
    catch {
        Write-Error "Failed to retrieve system uptime: $_"
    }
}

# Reload current user profile
function Invoke-Profile {
    . $PROFILE.CurrentUserAllHosts
}
Set-Alias -Name rep -Value Invoke-Profile
Set-Alias -Name Restart-Profile -Value Invoke-Profile

# Search using regex pattern
function grep($Regex, $Dir) {
    if ($Dir) {
        Get-ChildItem $Dir | Select-String $Regex
    } else {
        $input | Select-String $Regex
    }
}

# Show disk volumes
function df { Get-Volume }

# Replace text in file
function sed($File, $Find, $Replace) {
    (Get-Content -Raw $File).Replace($Find, $Replace) | Set-Content -NoNewline $File
}

# Show command path
function which($Name) {
    Get-Command $Name | Select-Object -ExpandProperty Definition
}

# Set environment variable
function export($Name, $Value) {
    Set-Item -Force -Path "env:$Name" -Value $Value
}

# Kill process by name
function pkill($Name) {
    Get-Process $Name -ErrorAction SilentlyContinue | Stop-Process
}

# Find process by name
function pgrep($Name) {
    Get-Process $Name
}

# Show first lines of file
function head {
    param($Path, $n = 10)
    Get-Content $Path -Head $n
}

# Show last lines of file
function tail {
    param($Path, $n = 10, [switch]$f = $false)
    Get-Content $Path -Tail $n -Wait:$f
}

# Create new file
function nf { param($Name) New-Item -ItemType "file" -Path . -Name $Name }

# Create directory and enter it
function mkcd { param($Dir) mkdir $Dir -Force; Set-Location $Dir }

# Move item to recycle bin
function trash($Path) {
    $FullPath = (Resolve-Path -Path $Path).Path
    if (Test-Path $FullPath) {
        $Shell = New-Object -ComObject 'Shell.Application'
        $ShellItem = $Shell.NameSpace((Split-Path $FullPath)).ParseName((Split-Path $FullPath -Leaf))
        $ShellItem.InvokeVerb('delete')
        Write-Host "Item moved to recycle bin: $FullPath"
    } else {
        Write-Host "Item not found: $FullPath" -ForegroundColor Red
    }
}

# Navigation shortcuts
function doc {
    $target = Join-Path $HOME 'Documents\1-GIT'
    if (Test-Path $target) { Set-Location -Path $target } else { Write-Warning "Folder not found: $target" }
  }
function fonts {
    $target = Join-Path $HOME 'Documents\1-GIT\win-fonts'
    if (Test-Path $target) { Set-Location -Path $target } else { Write-Warning "Folder not found: $target" }
  }  
function desk { Set-Location -Path ([Environment]::GetFolderPath("Desktop")) }
function down { Join-Path ([Environment]::GetFolderPath('UserProfile')) 'Downloads'}
function dev { Set-Location -Path 'C:\#PL-DEV' }
function gr {
    $target = Join-Path $HOME 'Documents\1-GIT'
    if (Test-Path $target) { Set-Location -Path $target } else { Write-Warning "Folder not found: $target" }
}

function wac {
    $target = Join-Path $HOME '.\Documents\1-GIT\win-apps-configs'
    if (Test-Path $target) { Set-Location -Path $target } else { Write-Warning "Folder not found: $target" }
}

# Process management
function k9 { Stop-Process -Name $args[0] }

# Enhanced directory listing
function la { Get-ChildItem | Format-Table -AutoSize }
function ll { Get-ChildItem -Force | Format-Table -AutoSize }

# Git shortcuts
function gs { git status }
function st { git status }
function ga { git add . }
function gc { param($m) git commit -m "$m" }
function gpush { git push }
function gpull { git pull }
function g { __zoxide_z github }
function gcl { git clone "$args" }
function gcom { git add .; git commit -m "$args" }
function lazyg { git add .; git commit -m "$args"; git push }
function gitp { git add .; git commit -m "$args"; git push }

# System information
function sysinfo { Get-ComputerInfo }

# Network utilities
function flushdns { Clear-DnsClientCache; Write-Host "DNS cache flushed" }

# Clipboard utilities
function cpy { Set-Clipboard $args[0] }
function pst { Get-Clipboard }

# Configure psreadline options
$PSReadLineOptions = @{
    EditMode = 'Windows'
    HistoryNoDuplicates = $true
    HistorySearchCursorMovesToEnd = $true
    Colors = @{
        Command = '#87CEEB'
        Parameter = '#98FB98'
        Operator = '#FFB6C1'
        Variable = '#DDA0DD'
        String = '#FFDAB9'
        Number = '#B0E0E6'
        Type = '#F0E68C'
        Comment = '#D3D3D3'
        Keyword = '#8367c7'
        Error = '#FF6347'
    }
    PredictionSource = 'History'
    PredictionViewStyle = 'ListView'
    BellStyle = 'None'
}
Set-PSReadLineOption @PSReadLineOptions

# Configure psreadline key handlers
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineKeyHandler -Chord 'Ctrl+w' -Function BackwardDeleteWord
Set-PSReadLineKeyHandler -Chord 'Alt+d' -Function DeleteWord
Set-PSReadLineKeyHandler -Chord 'Ctrl+LeftArrow' -Function BackwardWord
Set-PSReadLineKeyHandler -Chord 'Ctrl+RightArrow' -Function ForwardWord
Set-PSReadLineKeyHandler -Chord 'Ctrl+z' -Function Undo
Set-PSReadLineKeyHandler -Chord 'Ctrl+y' -Function Redo

# Filter sensitive commands from history
Set-PSReadLineOption -AddToHistoryHandler {
    param($Line)
    $Sensitive = @('password', 'secret', 'token', 'apikey', 'connectionstring')
    return -not ($Sensitive | Where-Object { $Line -match $_ })
}

# Configure command prediction
function Set-PredictionSource {
    if (Get-Command -Name "Set-PredictionSource_Override" -ErrorAction SilentlyContinue) {
        Set-PredictionSource_Override
    } else {
        Set-PSReadLineOption -PredictionSource HistoryAndPlugin
        Set-PSReadLineOption -MaximumHistoryCount 10000
    }
}
Set-PredictionSource

# Register custom command completions
$CompletionBlock = {
    param($WordToComplete, $CommandAst, $CursorPosition)
    $Completions = @{
        'git' = @('status', 'add', 'commit', 'push', 'pull', 'clone', 'checkout')
        'npm' = @('install', 'start', 'run', 'test', 'build')
        'deno' = @('run', 'compile', 'bundle', 'test', 'lint', 'fmt')
    }
    
    $Command = $CommandAst.CommandElements[0].Value
    if ($Completions.ContainsKey($Command)) {
        $Completions[$Command] | Where-Object { $_ -like "$WordToComplete*" } | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
    }
}
Register-ArgumentCompleter -Native -CommandName git, npm, deno -ScriptBlock $CompletionBlock

# Dotnet command completion
$DotnetCompleter = {
    param($WordToComplete, $CommandAst, $CursorPosition)
    dotnet complete --position $CursorPosition $CommandAst.ToString() | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock $DotnetCompleter

# Initialize starship prompt if available
if (Get-Command starship -ErrorAction SilentlyContinue) {
    $env:STARSHIP_CONFIG = "$env:USERPROFILE\Documents\PowerShell\starship.toml"
    if (-not (Test-Path $env:STARSHIP_CONFIG)) {
        Write-Host "Starship config not found at '$env:STARSHIP_CONFIG'" -ForegroundColor Yellow
    }
    Invoke-Expression (& starship init powershell)
} else {
    Write-Host "Install starship: winget install Starship.Starship" -ForegroundColor Yellow
}

# Initialize zoxide if available
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init --cmd z powershell | Out-String) })
} else {
    Write-Host "Install zoxide: winget install -e --id ajeetdsouza.zoxide" -ForegroundColor Yellow
}

# Update powershell to latest version
function Update-PowerShell {
    if (Get-Command -Name "Update-PowerShell_Override" -ErrorAction SilentlyContinue) {
        Update-PowerShell_Override
    } else {
        try {
            Write-Host "Checking for powershell updates..." -ForegroundColor Cyan
            $Current = $PSVersionTable.PSVersion.ToString()
            $Latest = (Invoke-RestMethod "https://api.github.com/repos/PowerShell/PowerShell/releases/latest").tag_name.Trim('v')
            
            if ($Current -lt $Latest) {
                Write-Host "Updating powershell..." -ForegroundColor Yellow
                Start-Process powershell.exe -ArgumentList "-NoProfile -Command winget upgrade Microsoft.PowerShell --accept-source-agreements --accept-package-agreements" -Wait -NoNewWindow
                Write-Host "Restart shell to apply updates" -ForegroundColor Magenta
            } else {
                Write-Host "PowerShell is current" -ForegroundColor Green
            }
        }
        catch {
            Write-Error "Update failed: $_"
        }
    }
}
Set-Alias -Name update -Value Update-PowerShell

# Display help information
function Show-Help {
    Write-Host @"
PowerShell 7 Profile — Command Reference

CORE UTILITIES
  ep                   Edit powershell profile
  admin [command]      Run as administrator
  rep                   Reload profile
  update               Update powershell

NAVIGATION
  doc                  Documents Folder
  desk                 Desktop Folder
  down                 Downloads Folder 
  dev                  Dev Folder (C:\#PL-DEV)
  gr                   Git Repositories Folder 
  mkcd [dir]           Create and enter directory
  la, ll               Enhanced file listing

FILE OPERATIONS
  nf [file]            Create new file
  touch [file]         Create empty file
  trash [path]         Move to recycle bin
  ff [pattern]         Find files

GIT WORKFLOW
  gs                   Status
  ga                   Add all
  gc [message]         Commit
  gpush, gpull         Sync repository
  lazyg [message]      Add, commit and push

SYSTEM
  sysinfo              System information
  uptime               Show uptime
  flushdns             Clear dns cache
  ip                   Public ip address

NETWORK
  pkill [process]      Terminate process
  pgrep [process]      Find process

"@ -ForegroundColor Cyan
}

# Record execution time and display welcome
Write-LastExecutionTime -Format 'o'
Write-Host "Profile loaded. Use 'Show-Help' for command reference" -ForegroundColor Green