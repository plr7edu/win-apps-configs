Set objShell = CreateObject("Shell.Application")
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Get the directory where this VBS script is located
strScriptPath = objFSO.GetParentFolderName(WScript.ScriptFullName)

' Define the PowerShell script name
strPSScript = "!Backup-AppConfigs.ps1"

' Full path to the PowerShell script
strFullPath = objFSO.BuildPath(strScriptPath, strPSScript)

' Check if the PowerShell script exists
If objFSO.FileExists(strFullPath) Then
    ' Launch Windows Terminal as Administrator with PowerShell script
    objShell.ShellExecute "wt.exe", "powershell.exe -NoExit -ExecutionPolicy Bypass -File """ & strFullPath & """", "", "runas", 1
Else
    MsgBox "Error: Cannot find " & strPSScript & " in the current directory." & vbCrLf & vbCrLf & "Please ensure the PowerShell script is in the same folder as this launcher.", vbCritical, "Script Not Found"
End If

Set objShell = Nothing
Set objFSO = Nothing