::Syncthing File Server (Restore)
cd %LOCALAPPDATA%
md Syncthing

xcopy /y /E "%HOMEPATH%\Documents\MY-GIT-REPO\windows-dotfiles\syncthing\Syncthing\*" "%LOCALAPPDATA%\Syncthing\"

