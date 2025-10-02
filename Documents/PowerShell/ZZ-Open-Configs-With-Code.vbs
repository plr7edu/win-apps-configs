Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Get the current directory where the script is running
strCurrentPath = objFSO.GetParentFolderName(WScript.ScriptFullName)

' Define the file paths
strFile1 = strCurrentPath & "\Microsoft.PowerShell_profile.ps1"
strFile2 = strCurrentPath & "\starship.toml"

' Build the VS Code command with trust flag
strCommand = "cmd /c code --new-window --disable-workspace-trust """ & strFile1 & """ """ & strFile2 & """"

' Execute the command silently (0 = hidden window, True = wait for completion)
objShell.Run strCommand, 0, False

' Clean up
Set objShell = Nothing
Set objFSO = Nothing