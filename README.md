# WinAppsConfigs

Simple backup and restore for selected Windows app configuration files.

## File/Folder Mapping (Repo ⇄ System)

| Application        | System Path                                           | Current Path                                      |
|--------------------|--------------------------------------------------------|---------------------------------------------------|
| Windows PowerShell | %USERPROFILE%\Documents\PowerShell                     | Documents/PowerShell                              |
| PowerToys          | %USERPROFILE%\Documents\PowerToys                      | Documents/PowerToys                               |
| Espanso            | %APPDATA%\espanso                                      | AppData/espanso                                   |
| JPEGView           | %APPDATA%\JPEGView                                     | AppData/JPEGView                                  |
| Directory Opus     | %APPDATA%\GPSoftware                                   | AppData/GPSoftware                                |
| JDownloader 2      | %LOCALAPPDATA%\JDownloader 2.0\cfg                     | LocalAppData/JDownloader 2.0/cfg                  |
| FileZilla (XML)    | %APPDATA%\FileZilla                                    | AppData/FileZilla/*.xml                           |
| Typora Themes      | %PROGRAMFILES%\Typora\resources\style\themes\*.css     | ProgramFiles/Typora/resources/style/themes/*.css  |

## Scripts
- `!Backup-AppConfigs.ps1` — backs up from system to repo.
- `!Restore-AppConfigs.ps1` — restores from repo to system.
- Launchers: `ZZ-Launch-Backup-AppConfigs.vbs`, `ZZ-Launch-Restore-AppConfigs.vbs`.

