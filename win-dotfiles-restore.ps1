
# Alaritty
Copy-Item -Path "$HOME\Documents\Windows-Git-Repos\windows-dotfiles\alacritty\*" -Destination "$env:APPDATA\alacritty\" -Recurse -Force

# Starship
Copy-Item -Path "$HOME\Documents\Windows-Git-Repos\windows-dotfiles\starship\" -Destination "$env:APPDATA\starship\" -Recurse -Force

# WindowsPowershell 5
Copy-Item -Path "$HOME\Documents\Windows-Git-Repos\windows-dotfiles\WindowsPowerShell\*" -Destination "$HOME\Documents\WindowsPowerShell\" -Recurse -Force

# WindowsPowershell 7
Copy-Item -Path "$HOME\Documents\Windows-Git-Repos\windows-dotfiles\WindowsPowerShell\*" -Destination "$HOME\Documents\PowerShell\" -Recurse -Force

# Windows Terminal
Copy-Item -Path "$HOME\Documents\Windows-Git-Repos\windows-dotfiles\Windows-Terminal-Settings\*" -Destination "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState" -Recurse -Force

# Espanso
Copy-Item -Path "$HOME\Documents\Windows-Git-Repos\windows-dotfiles\espanso" -Destination "$env:APPDATA" -Recurse -Force

# Jdonwloader2
Copy-Item -Path "$HOME\Documents\Windows-Git-Repos\windows-dotfiles\jdownloader2\laf" -Destination "$env:LOCALAPPDATA\JDownloader 2.0\cfg\" -Recurse -Force

# JPEGView
Copy-Item -Path "$HOME\Documents\Windows-Git-Repos\windows-dotfiles\jpegview\JPEGView\" -Destination "$env:APPDATA\JPEGView\" -Recurse -Force

# Typora (Themes)
Copy-Item -Path "$HOME\Documents\Windows-Git-Repos\windows-dotfiles\typora\themes\*" -Destination "$env:PROGRAMFILES\Typora\resources\style\themes\" -Recurse -Force

# New + Templates
Copy-Item -Path "$HOME\Documents\Windows-Git-Repos\windows-dotfiles\new+\*" -Destination "$env:LOCALAPPDATA\Microsoft\PowerToys\NewPlus\Templates" -Recurse -Force

Read-Host -Prompt "Press any key to continue"
