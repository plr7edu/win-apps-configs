::Syncthing File Server (Restore)
cd %LOCALAPPDATA%\Syncthing\
del /Q * & rd /s /q . 2>nul
xcopy /y /E "%HOMEPATH%\Documents\MY-GIT-REPO\windows-dotfiles\syncthing\Syncthing\*" %LOCALAPPDATA%\Syncthing\"

