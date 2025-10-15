#Requires AutoHotkey v2.0
#SingleInstance Force

; Get the current script directory
currentPath := A_ScriptDir

; Define file paths
file1 := currentPath "\Microsoft.PowerShell_profile.ps1"
file2 := currentPath "\starship.toml"

; Verify that the files exist before running VS Code
if !FileExist(file1) {
    MsgBox("Missing file: " file1)
    ExitApp
}

if !FileExist(file2) {
    MsgBox("Missing file: " file2)
    ExitApp
}

; Build the VS Code command
command := 'cmd /c code --new-window --disable-workspace-trust "' file1 '" "' file2 '"'

; Run the command hidden (no console window)
Run(command, , "Hide")

; Optional: exit the script after launching
ExitApp