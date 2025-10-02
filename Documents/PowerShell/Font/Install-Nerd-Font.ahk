; AutoHotkey v2.0 - System-Wide Font Installer with Auto-Elevation
; Installs CaskaydiaMonoNerdFontMono-Regular.ttf system-wide
; Full Dark Mode including Title Bar and Tray Menu

#Requires AutoHotkey v2.0
#SingleInstance Force

; Enable dark mode for title bar using DwmSetWindowAttribute
DWMWA_USE_IMMERSIVE_DARK_MODE := 20

; Font file name
fontFileName := "CaskaydiaMonoNerdFontMono-Regular.ttf"
fontName := "Cascaydia Mono Nerd Font Mono"

; Set dark tray menu
A_TrayMenu.Delete()
A_TrayMenu.Add("Exit", (*) => ExitApp())
TraySetIcon("shell32.dll", 222)

; Apply dark mode to tray menu using ordinal (undocumented API)
try {
    ; SetPreferredAppMode is ordinal 135 in uxtheme.dll
    DllCall(DllCall("GetProcAddress", "Ptr", DllCall("GetModuleHandle", "Str", "uxtheme", "Ptr"), "Ptr", 135, "Ptr"), "Int", 1)
    ; FlushMenuThemes is ordinal 136
    DllCall(DllCall("GetProcAddress", "Ptr", DllCall("GetModuleHandle", "Str", "uxtheme", "Ptr"), "Ptr", 136, "Ptr"))
}

; Check if running as admin
if !A_IsAdmin {
    ; Self-elevate with admin privileges
    try {
        if A_IsCompiled
            Run '*RunAs "' A_ScriptFullPath '" /restart'
        else
            Run '*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"'
    }
    ExitApp
}

; Main installation process
InstallFont()

; Function to install the font system-wide
InstallFont() {
    global fontFileName, fontName

    ; Get the script's directory
    scriptDir := A_ScriptDir
    fontPath := scriptDir "\" fontFileName

    ; Check if font file exists
    if !FileExist(fontPath) {
        ShowDarkMessageBox("Error: Font Installation Failed",
            "Font file not found:`n" fontFileName "`n`nPlease ensure the font file is in the same directory as this script.",
            true)
        return
    }

    ; Destination path for system fonts
    fontsFolder := A_WinDir "\Fonts"
    destPath := fontsFolder "\" fontFileName

    ; Copy font file to Windows Fonts folder
    try {
        FileCopy fontPath, destPath, 1  ; Overwrite if exists
    } catch as err {
        ShowDarkMessageBox("Error: Font Installation Failed",
            "Failed to copy font file to system folder.`n`nError: " err.Message,
            true)
        return
    }

    ; Register font in Windows Registry
    try {
        RegWrite fontFileName, "REG_SZ", "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts", fontName " (TrueType)"
    } catch as err {
        ShowDarkMessageBox("Error: Font Registration Failed",
            "Font file copied but registry registration failed.`n`nError: " err.Message,
            true)
        return
    }

    ; Notify system of font installation
    DllCall("AddFontResource", "Str", destPath)
    DllCall("SendMessage", "UInt", 0xFFFF, "UInt", 0x001D, "Ptr", 0, "Ptr", 0)  ; WM_FONTCHANGE

    ; Show success message
    ShowDarkMessageBox("Font Installation Successful",
        "✓ " fontName " has been successfully installed system-wide!`n`nThe font is now available for all applications.",
        false)
}

; Function to create and show dark-themed message box
ShowDarkMessageBox(title, message, isError) {
    global DWMWA_USE_IMMERSIVE_DARK_MODE

    ; Create dark-themed GUI
    darkGui := Gui("+AlwaysOnTop +Owner", title)
    darkGui.BackColor := "0x1E1E1E"  ; Dark background
    darkGui.SetFont("s10 c0xE0E0E0", "Segoe UI")  ; Light gray text

    ; Show GUI first (needed to get HWND)
    darkGui.Show("w450 h195 Center Hide")

    ; Apply dark mode to title bar
    hwnd := darkGui.Hwnd
    darkMode := 1
    DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", hwnd, "Int", DWMWA_USE_IMMERSIVE_DARK_MODE, "Int*", &darkMode, "Int", 4)

    ; Add icon (! for error, ✓ for success)
    icon := isError ? "⚠" : "✓"
    iconColor := isError ? "0xFF4444" : "0x4CAF50"
    darkGui.SetFont("s20 c" iconColor " Bold", "Segoe UI")
    darkGui.Add("Text", "x20 y20 w40 h40 Center", icon)

    ; Add message text
    darkGui.SetFont("s10 c0xE0E0E0", "Segoe UI")
    darkGui.Add("Text", "x70 y20 w360 h100", message)

    ; Add OK button with dark styling
    okBtn := darkGui.Add("Button", "x170 y140 w110 h35 Default", "OK")
    okBtn.SetFont("s10 c0xFFFFFF Bold", "Segoe UI")

    ; Apply dark theme to button
    DllCall("uxtheme\SetWindowTheme", "Ptr", okBtn.Hwnd, "Str", "DarkMode_Explorer", "Ptr", 0)

    ; Button click handler
    okBtn.OnEvent("Click", (*) => darkGui.Destroy())

    ; Handle GUI close
    darkGui.OnEvent("Close", (*) => ExitApp())
    darkGui.OnEvent("Escape", (*) => ExitApp())

    ; Now show the GUI with dark title bar applied
    darkGui.Show("w450 h195 Center")

    ; Wait for GUI to close
    WinWaitClose("ahk_id " hwnd)
    ExitApp()
}

; Handle script close events
OnExit(ExitFunc)
ExitFunc(ExitReason, ExitCode) {
    ExitApp
}