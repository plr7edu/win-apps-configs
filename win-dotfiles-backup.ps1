
# Alaritty
Copy-Item -Path "$env:APPDATA\alacritty\*" -Destination "$HOME\Documents\Windows-Git-Repos\windows-dotfiles\alacritty\" -Recurse -Force

# Espanso
Copy-Item -Path "$env:APPDATA\espanso\*" -Destination "$HOME\Documents\Windows-Git-Repos\windows-dotfiles\espanso" -Recurse -Force

# JPEGView
Copy-Item -Path "$env:APPDATA\JPEGView\*" -Destination "$HOME\Documents\Windows-Git-Repos\windows-dotfiles\jpegview\JPEGView\" -Recurse -Force

# WindowsPowershell
Copy-Item -Path "$HOME\Documents\PowerShell\*" -Destination "$HOME\Documents\Windows-Git-Repos\windows-dotfiles\WindowsPowerShell\" -Recurse -Force

# Windows Terminal
Copy-Item -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\*" -Destination "$HOME\Documents\Windows-Git-Repos\windows-dotfiles\Windows-Terminal-Settings\" -Recurse -Force

# New + Templates
Copy-Item -Path "$env:LOCALAPPDATA\Microsoft\PowerToys\NewPlus\Templates\*" -Destination "$HOME\Documents\Windows-Git-Repos\windows-dotfiles\new+" -Recurse -Force

%localappdata%\Microsoft\PowerToys\NewPlus\Templates

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$filePath = ".\$timestamp.txt"

# Create the file
New-Item -Path $filePath -ItemType "file"

# Add date and time to the file content
"File created on: $timestamp" | Out-File -Append -FilePath $filePath

Read-Host -Prompt "Press any key to continue"

