::Delete Last-Update_XXXX.txt
del "Last-Update-Time*.txt"


::Alacritty
xcopy /y "C:\Users\plr\AppData\Roaming\alacritty" "C:\Users\plr\Documents\GIT-REPO\windows-dotfiles\alacritty"

::Starship
xcopy /y "C:\Users\plr\AppData\Roaming\starship" "C:\Users\plr\Documents\GIT-REPO\windows-dotfiles\starship"

::Windows PowerShell
xcopy /y "C:\Users\plr\Documents\WindowsPowerShell" "C:\Users\plr\Documents\GIT-REPO\windows-dotfiles\WindowsPowerShell"

::Windows Terminal Settings Json
xcopy /y "C:\Users\plr\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" "C:\Users\plr\Documents\GIT-REPO\windows-dotfiles\Windows-Terminal-Settings"

::Geany
xcopy /y /E "C:\Users\plr\AppData\Roaming\geany\*" "C:\Users\plr\Documents\GIT-REPO\windows-dotfiles\geany\"

::Espanso
xcopy /y /E "C:\Users\plr\AppData\Roaming\espanso\*" "C:\Users\plr\Documents\GIT-REPO\windows-dotfiles\espanso\"

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
