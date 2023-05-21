::Delete Last-Update_XXXX.txt
del "Last-Update-Time*.txt"


::Alacritty
xcopy /y "%APPDATA%\alacritty\" "%HOMEPATH%\Documents\MY-GIT-REPO\windows-dotfiles\alacritty"

::Starship
xcopy /y "%APPDATA%\starship\" "%HOMEPATH%\Documents\MY-GIT-REPO\windows-dotfiles\starship"

::Windows PowerShell
xcopy /y "%HOMEPATH%\Documents\WindowsPowerShell" "%HOMEPATH%\Documents\MY-GIT-REPO\windows-dotfiles\WindowsPowerShell"

::Windows Terminal Settings Json
xcopy /y "%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" "%HOMEPATH%\Documents\MY-GIT-REPO\windows-dotfiles\Windows-Terminal-Settings"

::Geany
xcopy /y /E "%APPDATA%\geany\*" "%HOMEPATH%\Documents\MY-GIT-REPO\windows-dotfiles\geany\"

::Espanso
xcopy /y /E "%APPDATA%\espanso\*" "%HOMEPATH%\Documents\MY-GIT-REPO\windows-dotfiles\espanso\"

::FolderIco
xcopy /y /E "%PROGRAMDATA%\Teorex\FolderIco\*" "%HOMEPATH%\Documents\MY-GIT-REPO\windows-dotfiles\folderIco\"

::JPEGView
xcopy /y /E "%APPDATA%\JPEGView\*" "%HOMEPATH%\Documents\MY-GIT-REPO\windows-dotfiles\jpegview\"

::Easy Worship 7
::xcopy /y /E "%PROGRAMDATA%\Softouch\*" "%HOMEPATH%\Documents\MY-GIT-REPO\windows-dotfiles\easyworship7\programdata\"
::xcopy /y /E "%APPDATA%\Softouch\*" "%HOMEPATH%\Documents\MY-GIT-REPO\windows-dotfiles\easyworship7\roaming\"

::Create a Text file with current date and time

@echo off
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"

set "datestamp=%YYYY%%MM%%DD%" & set "timestamp=%HH%%Min%%Sec%"
set "fullstamp=%YYYY%-%MM%-%DD%_%HH%-%Min%"
::echo datestamp: "%datestamp%"
::echo timestamp: "%timestamp%"
::echo fullstamp: "%fullstamp%"

type nul > Last-Update-Time_%fullstamp%.txt
