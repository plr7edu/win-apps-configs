# WinAppsConfigs

Simple backup and restore for selected Windows app configuration files.

## File/Folder Mapping (Repo ⇄ System)

| Area         | Repo path                              | System path                                  | Notes                                      |
|--------------|----------------------------------------|----------------------------------------------|--------------------------------------------|
| Documents    | `Documents/PowerShell`                 | `%USERPROFILE%\Documents\PowerShell`         | PowerShell 7                               |
| Documents    | `Documents/PowerToys`                  | `%USERPROFILE%\Documents\PowerToys`          | PowerToys, PowerToys (NewPlus)             |
| AppData      | `AppData/espanso`                      | `%APPDATA%\espanso`                           | Espanso                                    |
| AppData      | `AppData/JPEGView`                     | `%APPDATA%\JPEGView`                          | JPEGView                                   |
| AppData      | `AppData/GPSoftware`                   | `%APPDATA%\GPSoftware`                        | Directory Opus                             |
| AppData      | `AppData/FileZilla/*.xml`              | `%APPDATA%\FileZilla`                         | XML files only                             |
| LocalAppData | `LocalAppData/JDownloader 2.0/cfg`     | `%LOCALAPPDATA%\JDownloader 2.0\cfg`         | Full configuration                         |
| ProgramFiles | `ProgramFiles/Typora/.../themes/*.css` | `%PROGRAMFILES%\Typora\resources\style\themes` | Typora themes (github‑dark variants)       |

## Scripts
- `!Backup-AppConfigs.ps1` — backs up from system to repo.
- `!Restore-AppConfigs.ps1` — restores from repo to system.
- Launchers: `ZZ-Launch-Backup-AppConfigs.vbs`, `ZZ-Launch-Restore-AppConfigs.vbs`.

