::Delete Last-Update_XXXX.txt
del "Last-Update-Time*.txt"

::Alacritty
xcopy /y "C:\Users\plr\AppData\Roaming\alacritty" "C:\Users\plr\Documents\GIT-REPO\win-dotfiles\alacritty"

::Starship
xcopy /y "C:\Users\plr\AppData\Roaming\starship" "C:\Users\plr\Documents\GIT-REPO\win-dotfiles\starship"

::Windows PowerShell
xcopy /y "C:\Users\plr\Documents\WindowsPowerShell" "C:\Users\plr\Documents\GIT-REPO\win-dotfiles\WindowsPowerShell"

::Windows Terminal Settings Json
xcopy /y "C:\Users\plr\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" "C:\Users\plr\Documents\GIT-REPO\win-dotfiles\Windows-Terminal-Settings"


::Create a Text file with current date and time
set CURRENTTIME=%date:~-7,2%"-"%date:~-10,2%"-"%date:~-4,4%"_"%time:~0,2%"."%time:~3,2%
type nul > Last-Update-Time_%CURRENTTIME%.txt
