
::Alaritty
xcopy "%HOMEPATH%\Documents\Windows-Git-Repos\windows-dotfiles\alacritty\" "%APPDATA%\alacritty\" 

::Starship
xcopy "%HOMEPATH%\Documents\Windows-Git-Repos\windows-dotfiles\starship\" "%APPDATA%\starship\"

::WindowsPowershell
xcopy "%HOMEPATH%\Documents\Windows-Git-Repos\windows-dotfiles\WindowsPowerShell\" "%HOMEPATH%\Documents\WindowsPowerShell\"

::Windows Terminal
xcopy /y "%HOMEPATH%\Documents\Windows-Git-Repos\windows-dotfiles\Windows-Terminal-Settings\*" "%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"

::Espanso
xcopy /y /E "%HOMEPATH%\Documents\Windows-Git-Repos\windows-dotfiles\espanso" "%APPDATA%\espanso\"

::Jdonwloader2
xcopy /y /E "%HOMEPATH%\Documents\Windows-Git-Repos\windows-dotfiles\jdownloader2\laf" "%LOCALAPPDATA%\JDownloader 2.0\cfg\"

::JPEGView
xcopy /y /E "%HOMEPATH%\Documents\Windows-Git-Repos\windows-dotfiles\jpegview\*" "%APPDATA%\JPEGView\"

::Typora (Themes)
xcopy /y /E "%HOMEPATH%\Documents\Windows-Git-Repos\windows-dotfiles\typora\themes\" "%APPDATA%\Typora\themes\"

pause