
::Alaritty
xcopy "%HOMEPATH%\Documents\MY-GIT-REPO\windows-dotfiles\alacritty\" "%APPDATA%\alacritty\" 

::Starship
xcopy "%HOMEPATH%\Documents\MY-GIT-REPO\windows-dotfiles\starship\" "%APPDATA%\starship\"

::WindowsPowershell
xcopy "%HOMEPATH%\Documents\MY-GIT-REPO\windows-dotfiles\WindowsPowerShell\" "%HOMEPATH%\Documents\WindowsPowerShell\"

::Windows Terminal
xcopy /y "%HOMEPATH%\Documents\MY-GIT-REPO\windows-dotfiles\Windows-Terminal-Settings\*" "%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"

::Espanso
xcopy /y /E "%HOMEPATH%\Documents\MY-GIT-REPO\windows-dotfiles\espanso" "%APPDATA%\espanso\"

::Jdonwloader2
xcopy /y /E "%HOMEPATH%\Documents\MY-GIT-REPO\windows-dotfiles\jdownloader2\" "%LOCALAPPDATA%\JDownloader 2.0\cfg\"

::JPEGView
xcopy /y /E "%HOMEPATH%\Documents\MY-GIT-REPO\windows-dotfiles\jpegview\*" "%APPDATA%\JPEGView\"

::Typora (Themes)
xcopy /y /E "%HOMEPATH%\Documents\MY-GIT-REPO\windows-dotfiles\typora\themes\" "%APPDATA%\Typora\themes\"

::Easy Worship 7
::xcopy /y /E "%HOMEPATH%\Documents\MY-GIT-REPO\windows-dotfiles\easyworship7\programdata\*" "%PROGRAMDATA%\Softouch\"
::xcopy /y /E "%HOMEPATH%\Documents\MY-GIT-REPO\windows-dotfiles\easyworship7\roaming\*" "%APPDATA%\Softouch\"

pause