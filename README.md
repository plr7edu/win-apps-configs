# WinAppsConfigs

Simple backup/restore for selected Windows app configs.

## Usage
- **Backup**: run `ZZ-Launch-Backup-AppConfigs.vbs` (Admin)
- **Restore**: run `ZZ-Launch-Restore-AppConfigs.vbs` (Admin)

## Scripts
- `!Backup-AppConfigs.ps1`
- `!Restore-AppConfigs.ps1`

## Restore Application

| Area         | Source (repo)           | Destination            | Includes                          |
|--------------|--------------------------|------------------------|-----------------------------------|
| Documents    | `Documents/*`           | `%USERPROFILE%\Documents` | PowerShell 7, PowerToys           |
| AppData      | `AppData/*`             | `%APPDATA%`            | Espanso, JPEGView                 |
| LocalAppData | `LocalAppData/*`        | `%LOCALAPPDATA%`       | JDownloader theme JSON            |
| ProgramFiles | `ProgramFiles/*`        | `%PROGRAMFILES%`       | Typora theme CSS files            |
