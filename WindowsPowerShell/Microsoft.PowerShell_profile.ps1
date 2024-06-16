#██████   ██████  ██     ██ ███████ ██████  ███████ ██   ██ ███████ ██      ██          ██████  ██████   ██████  ███████ ██ ██      ███████ 
#██   ██ ██    ██ ██     ██ ██      ██   ██ ██      ██   ██ ██      ██      ██          ██   ██ ██   ██ ██    ██ ██      ██ ██      ██      
#██████  ██    ██ ██  █  ██ █████   ██████  ███████ ███████ █████   ██      ██          ██████  ██████  ██    ██ █████   ██ ██      █████   
#██      ██    ██ ██ ███ ██ ██      ██   ██      ██ ██   ██ ██      ██      ██          ██      ██   ██ ██    ██ ██      ██ ██      ██      
#██       ██████   ███ ███  ███████ ██   ██ ███████ ██   ██ ███████ ███████ ███████     ██      ██   ██  ██████  ██      ██ ███████ ███████ 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
# Import Modules and External Profiles
# Ensure Terminal-Icons module is installed before importing
if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
    Install-Module -Name Terminal-Icons -Scope CurrentUser -Force -SkipPublisherCheck
}
Import-Module -Name Terminal-Icons
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}

# Admin Check and Prompt Customization
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
function prompt {
    if ($isAdmin) { "[" + (Get-Location) + "] # " } else { "[" + (Get-Location) + "] $ " }
}
$adminSuffix = if ($isAdmin) { " [ADMIN]" } else { "" }
$Host.UI.RawUI.WindowTitle = "PowerShell {0}$adminSuffix" -f $PSVersionTable.PSVersion.ToString()

# Utility Functions
function Test-CommandExists {
    param($command)
    $exists = $null -ne (Get-Command $command -ErrorAction SilentlyContinue)
    return $exists
}

# Editor Configuration
$EDITOR = if (Test-CommandExists nvim) { 'nvim' }
          elseif (Test-CommandExists pvim) { 'pvim' }
          elseif (Test-CommandExists vim) { 'vim' }
          elseif (Test-CommandExists vi) { 'vi' }
          elseif (Test-CommandExists code) { 'code' }
          elseif (Test-CommandExists notepad++) { 'notepad++' }
          elseif (Test-CommandExists sublime_text) { 'sublime_text' }
          else { 'notepad' }
Set-Alias -Name vim -Value $EDITOR

function Edit-Profile {
    vim $PROFILE.CurrentUserAllHosts
}
function touch($file) { "" | Out-File $file -Encoding ASCII }
function ff($name) {
    Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Output "$($_.directory)\$($_)"
    }
}

# Network Utilities
function Get-PubIP { (Invoke-WebRequest http://ifconfig.me/ip).Content }

# System Utilities
function uptime {
    if ($PSVersionTable.PSVersion.Major -eq 5) {
        Get-WmiObject win32_operatingsystem | Select-Object @{Name='LastBootUpTime'; Expression={$_.ConverttoDateTime($_.lastbootuptime)}} | Format-Table -HideTableHeaders
    } else {
        net statistics workstation | Select-String "since" | ForEach-Object { $_.ToString().Replace('Statistics since ', '') }
    }
}

function reload-profile {
    & $profile
}

# function unzip ($file) {
#     Write-Output("Extracting", $file, "to", $pwd)
#     $fullFile = Get-ChildItem -Path $pwd -Filter $file | ForEach-Object { $_.FullName }
#     Expand-Archive -Path $fullFile -DestinationPath $pwd
# }

# Unzip file using 7zip (Add 7zip to your PATH)
function expand-archive([string]$file, [string]$outputDir = '') {
	if (-not (Test-Path $file)) {
		$file = Resolve-Path $file
	}

	$baseName = get-childitem $file | select-object -ExpandProperty "BaseName"

	if ($outputDir -eq '') {
		$outputDir = $baseName
	}

# Just extract the file
	7z x "-o$outputDir" $file	
}

set-alias unzip expand-archive


function grep($regex, $dir) {
    if ( $dir ) {
        Get-ChildItem $dir | select-string $regex
        return
    }
    $input | select-string $regex
}

function df {
    get-volume
}

function sed($file, $find, $replace) {
    (Get-Content $file).replace("$find", $replace) | Set-Content $file
}

function which($name) {
    Get-Command $name | Select-Object -ExpandProperty Definition
}

function export($name, $value) {
    set-item -force -path "env:$name" -value $value;
}

function pkill($name) {
    Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}

function pgrep($name) {
    Get-Process $name
}

function head {
  param($Path, $n = 10)
  Get-Content $Path -Head $n
}

function tail {
  param($Path, $n = 10)
  Get-Content $Path -Tail $n
}

# Quick File Creation
function touch { param($name) New-Item -ItemType "file" -Path . -Name $name }

# Directory Management
function mkcd { param($dir) mkdir $dir -Force; Set-Location $dir }

# Find File
function find-file($name) {
	get-childitem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | foreach-object {
		write-output($PSItem.FullName)
	}
}

# Open File
function open($file) {
  invoke-item $file
}

# Windows Explorer
function ex {
  explorer.exe .
}

# Open with Sublime Text
function subl {
	& "$env:C:\Program Files\Sublime Text\sublime_text.exe" @args
}

# Open with VS Code
function code {
	& "$env:C:\Users\player-1\AppData\Local\Programs\Microsoft VS Code\Code.exe" @args
}


### Quality of Life Aliases

# Navigation Shortcuts
function doc { Set-Location -Path $HOME\Documents }

function desk { Set-Location -Path $HOME\Desktop }

function down { Set-Location -Path $HOME\Downloads }

function mu { Set-Location -Path $HOME\Music }

function vi { Set-Location -Path $HOME\Videos }

function ho { Set-Location -Path $HOME }

function gitd { Set-Location -Path $HOME\Documents\Windows-Git-Repos }

function dot { Set-Location -Path $HOME\Documents\Windows-Git-Repos\windows-dotfiles }

function wint { Set-Location -Path $HOME\Documents\Windows-Git-Repos\win-t }

function cpt { Set-Location -Path C:\Church-Presentation-Tools }

# Quick Access to Editing the Profile
function ep { code $PROFILE }

# Simplified Process Management
function k9 { Stop-Process -Name $args[0] }

# Enhanced Listing
function la { Get-ChildItem -Path . -Force | Format-Table -AutoSize }
function ll { Get-ChildItem -Path . -Force -Hidden | Format-Table -AutoSize }

# Git Shortcuts
function st { git status }

function ga { git add . }

function gc { param($m) git commit -m "$m" }

function gp { git push }

function g { z Git }

function gcom {
    git add .
    git commit -m "$args"
}

function gitp {
    git add .
    git commit -m "$args"
    git push
}

# Quick Access to System Information
function sysinfo { Get-ComputerInfo }

# Networking Utilities
function flushdns { Clear-DnsClientCache }

# Clipboard Utilities
function cpy { Set-Clipboard $args[0] }

function pst { Get-Clipboard }

# Enhanced PowerShell Experience
Set-PSReadLineOption -Colors @{
    Command = 'Yellow'
    Parameter = 'Green'
    String = 'DarkCyan'
}

## oh-my-posh Prompt
#oh-my-posh init pwsh --config https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/cobalt2.omp.json | Invoke-Expression
#oh-my-posh init pwsh --config 'C:\Users\player-1\Documents\Windows-Git-Repos\windows-dotfiles\ohmyposh\star.omp.json' | Invoke-Expression
#oh-my-posh init pwsh --config 'C:\Users\player-1\Documents\Windows-Git-Repos\windows-dotfiles\ohmyposh\spaceship.omp.json' | Invoke-Expression
oh-my-posh init pwsh --config 'C:\Users\player-1\Documents\Windows-Git-Repos\windows-dotfiles\ohmyposh\cobalt2.omp.json' | Invoke-Expression

# Starship Prompt
# Invoke-Expression (&starship init powershell)


# Zoxide
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
} else {
    Write-Host "zoxide command not found. Attempting to install via winget..."
    try {
        winget install -e --id ajeetdsouza.zoxide
        Write-Host "zoxide installed successfully. Initializing..."
        Invoke-Expression (& { (zoxide init powershell | Out-String) })
    } catch {
        Write-Error "Failed to install zoxide. Error: $_"
    }
}
