; Window Manager for Windows 11 - GUI-based, AutoHotkey v1.1 compatible
; Right-click tray icon for menu

; Application Information
global APP_NAME := "RestoreAllWindows"
global APP_VERSION := "1.0.0.3"
global APP_COMPANY := "nascent"
global APP_DESCRIPTION := "Minimize or Restore all Windows from a specific application. Restoring functionality lost in Windows 11."

;@Ahk2Exe-SetMainIcon restore.ico
;@Ahk2Exe-SetFileVersion 1.0.0.3
;@Ahk2Exe-SetProductVersion 1.0.0.3
;@Ahk2Exe-SetProductName RestoreAllWindows
;@Ahk2Exe-SetCompanyName nascent
;@Ahk2Exe-SetDescription Minimize or Restore all Windows from a specific application. Restoring functionality lost in Windows 11.

#NoEnv
#SingleInstance Force
SetBatchLines, -1
ListLines, Off
SetWorkingDir %A_ScriptDir%

; Global variables for storing process data
global g_processName1, g_processCount1, g_processTitle1, g_processMinimized1
global g_processName2, g_processCount2, g_processTitle2, g_processMinimized2
global g_processName3, g_processCount3, g_processTitle3, g_processMinimized3
global g_processName4, g_processCount4, g_processTitle4, g_processMinimized4
global g_processName5, g_processCount5, g_processTitle5, g_processMinimized5
global g_processName6, g_processCount6, g_processTitle6, g_processMinimized6
global g_processName7, g_processCount7, g_processTitle7, g_processMinimized7
global g_processName8, g_processCount8, g_processTitle8, g_processMinimized8
global g_processName9, g_processCount9, g_processTitle9, g_processMinimized9
global g_processName10, g_processCount10, g_processTitle10, g_processMinimized10
global g_processName11, g_processCount11, g_processTitle11, g_processMinimized11
global g_processName12, g_processCount12, g_processTitle12, g_processMinimized12
global g_processName13, g_processCount13, g_processTitle13, g_processMinimized13
global g_processName14, g_processCount14, g_processTitle14, g_processMinimized14
global g_processName15, g_processCount15, g_processTitle15, g_processMinimized15
global g_processName16, g_processCount16, g_processTitle16, g_processMinimized16
global g_processName17, g_processCount17, g_processTitle17, g_processMinimized17
global g_processName18, g_processCount18, g_processTitle18, g_processMinimized18
global g_processName19, g_processCount19, g_processTitle19, g_processMinimized19
global g_processName20, g_processCount20, g_processTitle20, g_processMinimized20
global g_totalProcesses := 0
global g_LVHwnd := 0

; Create custom tray menu
Menu, Tray, NoStandard
Menu, Tray, Add, Window Manager..., TrayWindowManager
Menu, Tray, Add
Menu, Tray, Add, Restore ALL Minimized Windows, TrayRestoreAll
Menu, Tray, Add, Minimize ALL Windows, TrayMinimizeAll
Menu, Tray, Add
Menu, Tray, Add, About..., TrayAbout
Menu, Tray, Add, Exit, TrayExit
Menu, Tray, Default, Window Manager...
Menu, Tray, Click, 1

return  ;

; Tray menu handlers
TrayWindowManager:
    BuildAndShowWindowManager()
return

TrayRestoreAll:
    count := RestoreAllWindows()
    if (count > 0)
        ToolTip, Restored %count% window(s) total
    else
        ToolTip, No minimized windows found
    SetTimer, RemoveToolTip, -2000
return

TrayMinimizeAll:
    count := MinimizeAllWindows()
    if (count > 0)
        ToolTip, Minimized %count% window(s) total
    else
        ToolTip, No visible windows found
    SetTimer, RemoveToolTip, -2000
return

TrayAbout:
    MsgBox, 64, About %APP_NAME%, 
    (
%APP_NAME%
Version: %APP_VERSION%

%APP_DESCRIPTION%

Author: %APP_COMPANY%
    )
return

TrayExit:
    ExitApp
return

BuildAndShowWindowManager() {
    global g_processName1, g_processCount1, g_processTitle1, g_processMinimized1
    global g_processName2, g_processCount2, g_processTitle2, g_processMinimized2
    global g_processName3, g_processCount3, g_processTitle3, g_processMinimized3
    global g_processName4, g_processCount4, g_processTitle4, g_processMinimized4
    global g_processName5, g_processCount5, g_processTitle5, g_processMinimized5
    global g_processName6, g_processCount6, g_processTitle6, g_processMinimized6
    global g_processName7, g_processCount7, g_processTitle7, g_processMinimized7
    global g_processName8, g_processCount8, g_processTitle8, g_processMinimized8
    global g_processName9, g_processCount9, g_processTitle9, g_processMinimized9
    global g_processName10, g_processCount10, g_processTitle10, g_processMinimized10
    global g_processName11, g_processCount11, g_processTitle11, g_processMinimized11
    global g_processName12, g_processCount12, g_processTitle12, g_processMinimized12
    global g_processName13, g_processCount13, g_processTitle13, g_processMinimized13
    global g_processName14, g_processCount14, g_processTitle14, g_processMinimized14
    global g_processName15, g_processCount15, g_processTitle15, g_processMinimized15
    global g_processName16, g_processCount16, g_processTitle16, g_processMinimized16
    global g_processName17, g_processCount17, g_processTitle17, g_processMinimized17
    global g_processName18, g_processCount18, g_processTitle18, g_processMinimized18
    global g_processName19, g_processCount19, g_processTitle19, g_processMinimized19
    global g_processName20, g_processCount20, g_processTitle20, g_processMinimized20
    global g_totalProcesses
    global g_LVHwnd

    g_totalProcesses := 0
    Loop, 20 {
        g_processName%A_Index% := ""
        g_processCount%A_Index% := 0
        g_processTitle%A_Index% := ""
        g_processMinimized%A_Index% := 0
    }
    
    WinGet, id, List

    Loop, %id% {
        hwnd := id%A_Index%
        
        WinGetTitle, title, ahk_id %hwnd%
        if (title = "")
            continue

        WinGet, proc, ProcessName, ahk_id %hwnd%
        if (proc = "")
            continue
        
        WinGet, mm, MinMax, ahk_id %hwnd%
        
        foundIndex := 0
        Loop, %g_totalProcesses% {
            if (g_processName%A_Index% = proc) {
                foundIndex := A_Index
                break
            }
        }

        if (foundIndex = 0) {
            if (g_totalProcesses < 20) {
                g_totalProcesses++
                g_processName%g_totalProcesses% := proc
                g_processCount%g_totalProcesses% := 1
                g_processTitle%g_totalProcesses% := title
                if (mm = -1)
                    g_processMinimized%g_totalProcesses% := 1
                else
                    g_processMinimized%g_totalProcesses% := 0
            }
        } else {
            g_processCount%foundIndex%++
            if (mm = -1) {
                g_processMinimized%foundIndex%++
            }
            if (StrLen(title) > StrLen(g_processTitle%foundIndex%)) {
                g_processTitle%foundIndex% := title
            }
        }
    }

    if (g_totalProcesses = 0) {
        ToolTip, No windows found.
        SetTimer, RemoveToolTip, -2000
        return
    }

    Gui, WinMgr: Destroy
    Gui, WinMgr: +AlwaysOnTop +ToolWindow
    Gui, WinMgr: Margin, 8, 8
    Gui, WinMgr: Font, s9, Segoe UI
    Gui, WinMgr: Add, Text,, Select application to manage windows (double-click to restore/minimize):
    Gui, WinMgr: Add, ListView, w620 r12 Grid HwndLVHwnd gWinMgrListViewEvent, Application|Total|Minimized|Visible|Example title
    
    g_LVHwnd := LVHwnd
    
    Gui, WinMgr: Default
    Gui, WinMgr: ListView, ahk_id %LVHwnd%
    
    Loop, %g_totalProcesses% {
        proc := g_processName%A_Index%
        cnt := g_processCount%A_Index%
        minCnt := g_processMinimized%A_Index%
        visCnt := cnt - minCnt
        ex := g_processTitle%A_Index%
        
        if (StrLen(ex) > 50)
            ex := SubStr(ex, 1, 47) . "..."
        
        LV_Add("", proc, cnt, minCnt, visCnt, ex)
    }

    LV_ModifyCol(1, 180)
    LV_ModifyCol(2, 60, "Center")
    LV_ModifyCol(3, 80, "Center")
    LV_ModifyCol(4, 60, "Center")
    LV_ModifyCol(5, 240)

    Gui, WinMgr: Add, Button, gRestoreButton w110, Restore
    Gui, WinMgr: Add, Button, x+8 gMinimizeButton w110, Minimize
    Gui, WinMgr: Add, Button, x+8 gRestoreAllButton w120, Restore All
    Gui, WinMgr: Add, Button, x+8 gMinimizeAllButton w120, Minimize All
    Gui, WinMgr: Add, Button, x+8 gCancelButton w90, Cancel

    Gui, WinMgr: Show, AutoSize Center, Window Manager
    
    LV_Modify(1, "Select Focus")
    return
}

WinMgrListViewEvent:
    if (A_GuiEvent = "DoubleClick") {
        global g_processMinimized1, g_processMinimized2, g_processMinimized3, g_processMinimized4, g_processMinimized5
        global g_processMinimized6, g_processMinimized7, g_processMinimized8, g_processMinimized9, g_processMinimized10
        global g_processMinimized11, g_processMinimized12, g_processMinimized13, g_processMinimized14, g_processMinimized15
        global g_processMinimized16, g_processMinimized17, g_processMinimized18, g_processMinimized19, g_processMinimized20
        global g_LVHwnd
        
        Gui, WinMgr: Default
        Gui, WinMgr: ListView, ahk_id %g_LVHwnd%
        Row := LV_GetNext()
        if (Row = 0)
            return
        
        if (g_processMinimized%Row% > 0) {
            Gosub, RestoreButton
        } else {
            Gosub, MinimizeButton
        }
    }
return

RestoreButton:
    global g_processName1, g_processName2, g_processName3, g_processName4, g_processName5
    global g_processName6, g_processName7, g_processName8, g_processName9, g_processName10
    global g_processName11, g_processName12, g_processName13, g_processName14, g_processName15
    global g_processName16, g_processName17, g_processName18, g_processName19, g_processName20
    global g_LVHwnd
    
    Gui, WinMgr: Default
    Gui, WinMgr: ListView, ahk_id %g_LVHwnd%
    Row := LV_GetNext()
    if (Row = 0) {
        SoundBeep, 1500, 80
        return
    }
    
    proc := g_processName%Row%
    count := RestoreWindowsByProcess(proc)
    if (count > 0)
        ToolTip, Restored %count% window(s) of %proc%
    else
        ToolTip, No minimized windows found for %proc%
    SetTimer, RemoveToolTip, -2000
    Gui, WinMgr: Destroy
return

MinimizeButton:
    global g_processName1, g_processName2, g_processName3, g_processName4, g_processName5
    global g_processName6, g_processName7, g_processName8, g_processName9, g_processName10
    global g_processName11, g_processName12, g_processName13, g_processName14, g_processName15
    global g_processName16, g_processName17, g_processName18, g_processName19, g_processName20
    global g_LVHwnd
    
    Gui, WinMgr: Default
    Gui, WinMgr: ListView, ahk_id %g_LVHwnd%
    Row := LV_GetNext()
    if (Row = 0) {
        SoundBeep, 1500, 80
        return
    }
    
    proc := g_processName%Row%
    count := MinimizeWindowsByProcess(proc)
    if (count > 0)
        ToolTip, Minimized %count% window(s) of %proc%
    else
        ToolTip, No visible windows found for %proc%
    SetTimer, RemoveToolTip, -2000
    Gui, WinMgr: Destroy
return

RestoreAllButton:
    count := RestoreAllWindows()
    if (count > 0)
        ToolTip, Restored %count% window(s) total
    else
        ToolTip, No minimized windows found
    SetTimer, RemoveToolTip, -2000
    Gui, WinMgr: Destroy
return

MinimizeAllButton:
    count := MinimizeAllWindows()
    if (count > 0)
        ToolTip, Minimized %count% window(s) total
    else
        ToolTip, No visible windows found
    SetTimer, RemoveToolTip, -2000
    Gui, WinMgr: Destroy
return

CancelButton:
    Gui, WinMgr: Destroy
return

WinMgrGuiClose:
    Gui, WinMgr: Destroy
return

RestoreWindowsByProcess(processName) {
    count := 0
    WinGet, id, List, ahk_exe %processName%
    Loop, %id% {
        hwnd := id%A_Index%
        WinGet, mm, MinMax, ahk_id %hwnd%
        if (mm = -1) {
            WinGetTitle, title, ahk_id %hwnd%
            if (title != "") {
                WinRestore, ahk_id %hwnd%
                count++
            }
        }
    }
    return count
}

MinimizeWindowsByProcess(processName) {
    count := 0
    WinGet, id, List, ahk_exe %processName%
    Loop, %id% {
        hwnd := id%A_Index%
        WinGet, mm, MinMax, ahk_id %hwnd%
        if (mm != -1) {
            WinGetTitle, title, ahk_id %hwnd%
            if (title != "") {
                WinMinimize, ahk_id %hwnd%
                count++
            }
        }
    }
    return count
}

RestoreAllWindows() {
    count := 0
    WinGet, id, List
    Loop, %id% {
        hwnd := id%A_Index%
        WinGet, mm, MinMax, ahk_id %hwnd%
        if (mm = -1) {
            WinGetTitle, title, ahk_id %hwnd%
            if (title != "") {
                WinRestore, ahk_id %hwnd%
                count++
            }
        }
    }
    return count
}

MinimizeAllWindows() {
    count := 0
    WinGet, id, List
    Loop, %id% {
        hwnd := id%A_Index%
        WinGet, mm, MinMax, ahk_id %hwnd%
        if (mm != -1) {
            WinGetTitle, title, ahk_id %hwnd%
            if (title != "") {
                WinMinimize, ahk_id %hwnd%
                count++
            }
        }
    }
    return count
}

RemoveToolTip:
    ToolTip
return

