#Persistent
#SingleInstance
SetStoreCapsLockMode, Off
GroupAdd, EVEWindows, EVE -

; --- Root tracking ---
RootKey := ""
RootJustFired := False
LastSigId := ""
LastFinisherWasAlpha := False
RootModeActive := False
ZeroMode := False
ReadyToIncrement := False

; Used slot tracking
UsedNums := {}
UsedAlphas := {}
NextNum := 1
NextAlpha := 1
LastUsedNum := ""
LastUsedAlpha := ""

; --- Keybind defaults ---
KB_Copy        := ""
KB_Paste       := ""
KB_GrabSig     := ""
KB_SetRoot     := ""
KB_FormatEnf   := ""
KB_FinH        := ""
KB_Fin13       := ""
KB_Fin1        := ""
KB_Fin2        := ""
KB_Fin3        := ""
KB_Fin4        := ""
KB_Fin5        := ""
KB_Fin6        := ""
KB_FinETag     := ""
KB_FinSlash    := ""
KB_FinN        := ""
KB_FinL        := ""
KB_FinM        := ""
KB_FinS        := ""
KB_FinC        := ""

; Maps hotkey string -> label, so we can disable by exact label
HotkeyLabelMap := {}

; --- Tray setup ---
Menu, Tray, NoStandard
Menu, Tray, Add, Open GUI, ShowMainGui
Menu, Tray, Add, Reload Script, ReloadScript
Menu, Tray, Add, Exit, ExitScript
Menu, Tray, Default, Open GUI
Menu, Tray, Tip, EVE Bookmark Helper

; Single INI file for everything
IniFile := "eve_bookmark_helper.ini"

; Load or create settings
GoSub, LoadAllSettings
GoSub, RefreshHotkeys
SetTimer, RefreshHotkeys, 10000
SetTimer, RefreshStatusTab, 2000

; Initialize to Home/Zero mode by default
RootModeActive := True
RootKey := ""
ZeroMode := False
ReadyToIncrement := False
RootJustFired := False
UsedNums := {}
UsedAlphas := {}
NextNum := 1
NextAlpha := 1
LastUsedNum := ""
LastUsedAlpha := ""

; Show GUI on launch
GoSub, ShowMainGui

Return

ExitScript:
ExitApp
Return

ReloadScript:
Reload
Return

LoadAllSettings:
; Create INI file with defaults if it doesn't exist
IfNotExist, %IniFile%
{
    GoSub, SaveAllSettings
    Return
}

; Load window enabled settings
IniRead, EnabledSection, %IniFile%, Enabled
; No need to store globally, will be read in RefreshHotkeys

; Load keybindings
IniRead, KB_Copy,      %IniFile%, Keybinds, Copy,      
IniRead, KB_Paste,     %IniFile%, Keybinds, Paste,     
IniRead, KB_GrabSig,   %IniFile%, Keybinds, GrabSig,   
IniRead, KB_SetRoot,   %IniFile%, Keybinds, SetRoot,   
IniRead, KB_FormatEnf, %IniFile%, Keybinds, FormatEnf, 
IniRead, KB_FinH,      %IniFile%, Keybinds, FinH,      
IniRead, KB_Fin13,     %IniFile%, Keybinds, Fin13,     
IniRead, KB_Fin1,      %IniFile%, Keybinds, Fin1,      
IniRead, KB_Fin2,      %IniFile%, Keybinds, Fin2,      
IniRead, KB_Fin3,      %IniFile%, Keybinds, Fin3,      
IniRead, KB_Fin4,      %IniFile%, Keybinds, Fin4,      
IniRead, KB_Fin5,      %IniFile%, Keybinds, Fin5,      
IniRead, KB_Fin6,      %IniFile%, Keybinds, Fin6,      
IniRead, KB_FinETag,   %IniFile%, Keybinds, FinETag,   
IniRead, KB_FinSlash,  %IniFile%, Keybinds, FinSlash,  
IniRead, KB_FinN,      %IniFile%, Keybinds, FinN,      
IniRead, KB_FinL,      %IniFile%, Keybinds, FinL,      
IniRead, KB_FinM,      %IniFile%, Keybinds, FinM,      
IniRead, KB_FinS,      %IniFile%, Keybinds, FinS,      
IniRead, KB_FinC,      %IniFile%, Keybinds, FinC,      
Return

SaveAllSettings:
; Save all keybindings
IniWrite, %KB_Copy%,      %IniFile%, Keybinds, Copy
IniWrite, %KB_Paste%,     %IniFile%, Keybinds, Paste
IniWrite, %KB_GrabSig%,   %IniFile%, Keybinds, GrabSig
IniWrite, %KB_SetRoot%,   %IniFile%, Keybinds, SetRoot
IniWrite, %KB_FormatEnf%, %IniFile%, Keybinds, FormatEnf
IniWrite, %KB_FinH%,      %IniFile%, Keybinds, FinH
IniWrite, %KB_Fin13%,     %IniFile%, Keybinds, Fin13
IniWrite, %KB_Fin1%,      %IniFile%, Keybinds, Fin1
IniWrite, %KB_Fin2%,      %IniFile%, Keybinds, Fin2
IniWrite, %KB_Fin3%,      %IniFile%, Keybinds, Fin3
IniWrite, %KB_Fin4%,      %IniFile%, Keybinds, Fin4
IniWrite, %KB_Fin5%,      %IniFile%, Keybinds, Fin5
IniWrite, %KB_Fin6%,      %IniFile%, Keybinds, Fin6
IniWrite, %KB_FinETag%,   %IniFile%, Keybinds, FinETag
IniWrite, %KB_FinSlash%,  %IniFile%, Keybinds, FinSlash
IniWrite, %KB_FinN%,      %IniFile%, Keybinds, FinN
IniWrite, %KB_FinL%,      %IniFile%, Keybinds, FinL
IniWrite, %KB_FinM%,      %IniFile%, Keybinds, FinM
IniWrite, %KB_FinS%,      %IniFile%, Keybinds, FinS
IniWrite, %KB_FinC%,      %IniFile%, Keybinds, FinC

; Save window enabled settings (preserve existing if any)
Loop % GuiWinTotalControls
{
    WinTitle := WinControlIndex%A_Index%
    VarName := "WCB" . A_Index
    GuiControlGet, Val, Main:, %VarName%
    IniWrite, %Val%, %IniFile%, Enabled, %WinTitle%
}
Return

SaveWindowSettings:
; Save only window enabled settings
Loop % GuiWinTotalControls
{
    WinTitle := WinControlIndex%A_Index%
    VarName := "WCB" . A_Index
    GuiControlGet, Val, Main:, %VarName%
    IniWrite, %Val%, %IniFile%, Enabled, %WinTitle%
}
Return

KBDisplay(kb) {
    if (kb = "")
        return "(none)"
    
    Display := kb
    
    ; Handle modifier prefixes at the start of the string
    ; Process them in order, removing each as we go
    Modifiers := ""
    
    ; Check for Ctrl (^)
    while (SubStr(Display, 1, 1) = "^") {
        Modifiers .= "Ctrl+"
        Display := SubStr(Display, 2)
    }
    
    ; Check for Alt (!)
    while (SubStr(Display, 1, 1) = "!") {
        Modifiers .= "Alt+"
        Display := SubStr(Display, 2)
    }
    
    ; Check for Shift (+)
    while (SubStr(Display, 1, 1) = "+") {
        Modifiers .= "Shift+"
        Display := SubStr(Display, 2)
    }
    
    ; Handle special vk codes (these are for punctuation keys)
    ; Only do this if the remaining Display starts with "vk"
    if (SubStr(Display, 1, 2) = "vk") {
        if (Display = "vkDE")
            Display := "'"
        else if (Display = "vkBC")
            Display := ","
        else if (Display = "vkBE")
            Display := "."
        else if (Display = "vkBF")
            Display := "/"
        else if (Display = "vkC0")
            Display := "`"
        else if (Display = "vk3B")
            Display := ";"
        else if (Display = "vkDB")
            Display := "["
        else if (Display = "vkDD")
            Display := "]"
        else if (Display = "vkDC")
            Display := "\"
        else if (Display = "vkBD")
            Display := "-"
        else if (Display = "vkBB")
            Display := "="
    }
    
    ; Handle the backtick escape if present
    if (Display = "``")
        Display := "`"
    
    ; Return modifiers + key
    return Modifiers . Display
}

ShowMainGui:
GoSub, BuildMainGui
Return

BuildMainGui:
Gui, Main:Destroy
Gui, Main:New, +AlwaysOnTop, ABH Bookmark Helper
Gui, Main:Font, s10
Gui, Main:Add, Tab3, vMainTab w520 h530, Status|Windows|Keybinds|About

Gui, Main:Tab, 1
Gui, Main:Font, s10 bold
Gui, Main:Add, Text, x20 y50,  Current Sig ID:
Gui, Main:Add, Text, x20 y78,  Root System:
Gui, Main:Add, Text, x20 y106, Root Mode:
Gui, Main:Add, Text, x20 y134, Next Numeric:
Gui, Main:Add, Text, x20 y162, Next Alpha:
Gui, Main:Font, s10 norm
Gui, Main:Add, Text, vStatusSig       x200 y50  w250, ---
Gui, Main:Add, Text, vStatusRoot      x200 y78  w250, ---
Gui, Main:Add, Text, vStatusMode      x200 y106 w250, ---
Gui, Main:Add, Text, vStatusNextNum   x200 y134 w250, ---
Gui, Main:Add, Text, vStatusNextAlpha x200 y162 w250, ---
Gui, Main:Font, s10 bold
Gui, Main:Add, Text, x20 y200, Set Root Manually:
Gui, Main:Font, s10 norm
Gui, Main:Add, Edit,   vManualRoot x20  y222 w160
Gui, Main:Add, Button, x188 y220 w80 gSetManualRoot, Set Root
Gui, Main:Add, Button, x276 y220 w80 gClearRoot,     Clear Root

Gui, Main:Tab, 2
Gui, Main:Font, s9
Gui, Main:Add, Text, x20 y50 w480, Select which EVE windows have hotkeys active:
Gui, Main:Add, Button, x20 y70 w80 gRefreshWinList, Refresh
WinList := []
WinGet, AllIDs, List
Loop % AllIDs
{
    ID := AllIDs%A_Index%
    WinGetTitle, Title, ahk_id %ID%
    if (Title ~= "^EVE - ") {
        AlreadyAdded := False
        Loop % WinList.MaxIndex()
        {
            if (WinList[A_Index] = Title) {
                AlreadyAdded := True
                Break
            }
        }
        if (!AlreadyAdded)
            WinList.Push(Title)
    }
}
WinYPos := 100
if (WinList.MaxIndex() = 0) {
    Gui, Main:Add, Text, x20 y%WinYPos%, No EVE windows found.
} else {
    Loop % WinList.MaxIndex()
    {
        WinTitle := WinList[A_Index]
        IniRead, Saved, %IniFile%, Enabled, %WinTitle%, 0
        Checked := Saved ? "Checked" : ""
        VarName := "WCB" . A_Index
        Gui, Main:Add, CheckBox, x20 y%WinYPos% v%VarName% %Checked% gOnWinCheck, %WinTitle%
        WinControlIndex%A_Index% := WinTitle
        WinTotalControls := A_Index
        WinYPos += 24
    }
}
GuiWinTotalControls := WinTotalControls

Gui, Main:Tab, 3
Gui, Main:Font, s9 bold
Gui, Main:Add, Text, x20 y50 w220, Function
Gui, Main:Add, Text, x250 y50 w220, Hotkey (click then press combo)
Gui, Main:Font, s9 norm
KBDefs := []
KBDefs.Push(["Copy",                      "KB_Copy"])
KBDefs.Push(["Paste",                     "KB_Paste"])
KBDefs.Push(["Grab Sig ID",               "KB_GrabSig"])
KBDefs.Push(["Set Root",                  "KB_SetRoot"])
KBDefs.Push(["Format Enforcer",           "KB_FormatEnf"])
KBDefs.Push(["Finisher: HS (highsec)",     "KB_FinH"])
KBDefs.Push(["Finisher: LS (lowsec)",      "KB_FinL"])
KBDefs.Push(["Finisher: NS (nullsec)",     "KB_FinN"])
KBDefs.Push(["Finisher: C13 (shattered)",  "KB_Fin13"])
KBDefs.Push(["Finisher: C1",               "KB_Fin1"])
KBDefs.Push(["Finisher: C2",               "KB_Fin2"])
KBDefs.Push(["Finisher: C3",               "KB_Fin3"])
KBDefs.Push(["Finisher: C4",               "KB_Fin4"])
KBDefs.Push(["Finisher: C5",               "KB_Fin5"])
KBDefs.Push(["Finisher: C6",               "KB_Fin6"])
KBDefs.Push(["E Tag (end of life)",       "KB_FinETag"])
KBDefs.Push(["/ Tag (half mass)",         "KB_FinSlash"])
KBDefs.Push(["M Tag (medium hole)",       "KB_FinM"])
KBDefs.Push(["S Tag (frig hole)",         "KB_FinS"])
KBDefs.Push(["C Tag (critical)",          "KB_FinC"])
KBYPos := 68
Loop % KBDefs.MaxIndex()
{
    FuncName := KBDefs[A_Index][1]
    VarRef   := KBDefs[A_Index][2]
    CurVal   := %VarRef%
    CtrlName := "KBCtrl" . A_Index
    KBCtrlRef%A_Index% := VarRef
    Gui, Main:Add, Text,   x20  y%KBYPos% w220, %FuncName%
    Gui, Main:Add, Hotkey, x250 y%KBYPos% w220 v%CtrlName% gKBChange Limit1, %CurVal%
    KBYPos += 22
}
KBTotalCtrls := KBDefs.MaxIndex()
Gui, Main:Add, Button, x20 y%KBYPos% w120 gResetKeybinds, Reset Defaults

Gui, Main:Tab, 4
Gui, Main:Font, s9

; Force reload from INI to ensure we have current values for About tab
IniRead, KB_Copy,      %IniFile%, Keybinds, Copy,      
IniRead, KB_Paste,     %IniFile%, Keybinds, Paste,     
IniRead, KB_GrabSig,   %IniFile%, Keybinds, GrabSig,   
IniRead, KB_SetRoot,   %IniFile%, Keybinds, SetRoot,   
IniRead, KB_FormatEnf, %IniFile%, Keybinds, FormatEnf, 
IniRead, KB_FinH,      %IniFile%, Keybinds, FinH,      
IniRead, KB_Fin13,     %IniFile%, Keybinds, Fin13,     
IniRead, KB_Fin1,      %IniFile%, Keybinds, Fin1,      
IniRead, KB_Fin2,      %IniFile%, Keybinds, Fin2,      
IniRead, KB_Fin3,      %IniFile%, Keybinds, Fin3,      
IniRead, KB_Fin4,      %IniFile%, Keybinds, Fin4,      
IniRead, KB_Fin5,      %IniFile%, Keybinds, Fin5,      
IniRead, KB_Fin6,      %IniFile%, Keybinds, Fin6,      
IniRead, KB_FinETag,   %IniFile%, Keybinds, FinETag,   
IniRead, KB_FinSlash,  %IniFile%, Keybinds, FinSlash,  
IniRead, KB_FinN,      %IniFile%, Keybinds, FinN,      
IniRead, KB_FinL,      %IniFile%, Keybinds, FinL,      
IniRead, KB_FinM,      %IniFile%, Keybinds, FinM,      
IniRead, KB_FinS,      %IniFile%, Keybinds, FinS,      
IniRead, KB_FinC,      %IniFile%, Keybinds, FinC      

d_Copy      := KBDisplay(KB_Copy)
d_Paste     := KBDisplay(KB_Paste)
d_GrabSig   := KBDisplay(KB_GrabSig)
d_SetRoot   := KBDisplay(KB_SetRoot)
d_FormatEnf := KBDisplay(KB_FormatEnf)
d_FinH      := KBDisplay(KB_FinH)
d_FinL      := KBDisplay(KB_FinL)
d_FinN      := KBDisplay(KB_FinN)
d_Fin13     := KBDisplay(KB_Fin13)
d_Fin1      := KBDisplay(KB_Fin1)
d_Fin2      := KBDisplay(KB_Fin2)
d_Fin3      := KBDisplay(KB_Fin3)
d_Fin4      := KBDisplay(KB_Fin4)
d_Fin5      := KBDisplay(KB_Fin5)
d_Fin6      := KBDisplay(KB_Fin6)
d_FinETag   := KBDisplay(KB_FinETag)
d_FinSlash  := KBDisplay(KB_FinSlash)
d_FinM      := KBDisplay(KB_FinM)
d_FinS      := KBDisplay(KB_FinS)
d_FinC      := KBDisplay(KB_FinC)

AboutText =
(
%d_Copy% - Copy
%d_Paste% - Paste
%d_GrabSig% - Grab sig ID (first 3 chars)
%d_SetRoot% - Set root from selected bookmark(s)
%d_FormatEnf% - Format enforcer

%d_FinH% - H (highsec)
%d_FinL% - L (lowsec)
%d_FinN% - N (nullsec)
%d_Fin13% - 13 (shattered)
%d_Fin1% - C1
%d_Fin2% - C2
%d_Fin3% - C3
%d_Fin4% - C4
%d_Fin5% - C5
%d_Fin6% - C6

%d_FinETag% - E flag (end of life)
%d_FinSlash% - / flag (half mass)
%d_FinM% - M flag (medium hole)
%d_FinS% - S flag (frig hole)
%d_FinC% - C flag (critical)

Root: set via %d_SetRoot% on a bookmark.
Empty clipboard = home/zero mode.
%d_GrabSig% arms increment. First finisher
increments and pastes. Further finishers
before next %d_GrabSig% correct in place.
)
Gui, Main:Add, Text, x20 y48 w480, %AboutText%

Gui, Main:Tab
Gui, Main:Add, Button, x20 y545 w80 gMainGuiClose, Close
Gui, Main:Show, w540 h595
Return

MainGuiClose:
Gui, Main:Hide
Return

RefreshWinList:
GoSub, BuildMainGui
Return

OnWinCheck:
GoSub, SaveWindowSettings
GoSub, RefreshHotkeys
Return

RefreshStatusTab:
if (RootModeActive) {
    ModeText      := RootKey = "" ? "Home/Zero" : "Active"
    RootText      := RootKey = "" ? "(home)" : RootKey
    NextNumText   := BuildSystemKey(RootKey, NextNum,   False)
    NextAlphaText := BuildSystemKey(RootKey, NextAlpha, True)
} else {
    ModeText      := "Not set"
    RootText      := "---"
    NextNumText   := "---"
    NextAlphaText := "---"
}
SigText := LastSigId = "" ? "---" : LastSigId
GuiControl, Main:, StatusSig,        %SigText%
GuiControl, Main:, StatusRoot,       %RootText%
GuiControl, Main:, StatusMode,       %ModeText%
GuiControl, Main:, StatusNextNum,    %NextNumText%
GuiControl, Main:, StatusNextAlpha,  %NextAlphaText%
Return

SetManualRoot:
GuiControlGet, ManualRoot, Main:, ManualRoot
ManualRoot := Trim(ManualRoot)
StringUpper, ManualRoot, ManualRoot
if (ManualRoot = "") {
    GoSub, ClearRoot
    Return
}
RootKey              := ManualRoot
RootModeActive       := True
ZeroMode             := False
ReadyToIncrement     := False
RootJustFired        := False
LastFinisherWasAlpha := False
UsedNums             := {}
UsedAlphas           := {}
NextNum              := 1
NextAlpha            := 1
LastUsedNum          := ""
LastUsedAlpha        := ""
GoSub, ShowRootTooltip
Return

ClearRoot:
; Set to Home/Zero mode instead of disabling completely
RootKey          := ""
RootModeActive   := True
ZeroMode         := False
ReadyToIncrement := False
RootJustFired    := False
UsedNums         := {}
UsedAlphas       := {}
NextNum          := 1
NextAlpha        := 1
LastUsedNum      := ""
LastUsedAlpha    := ""
ToolTip, Root cleared - now in Home/Zero mode
SetTimer, RemoveTooltip, -1500
GoSub, ShowRootTooltip
Return

KBChange:
Loop % KBTotalCtrls
{
    CtrlName := "KBCtrl" . A_Index
    if (A_GuiControl = CtrlName) {
        VarRef := KBCtrlRef%A_Index%
        GuiControlGet, NewKey, Main:, %CtrlName%
        ; Check if the hotkey was cleared (set to "None" or empty)
        if (NewKey = "" || NewKey = "None") {
            ; Set the variable to empty string to disable it
            %VarRef% := ""
        } else {
            %VarRef% := NewKey
        }
        GoSub, SaveAllSettings
        GoSub, RefreshHotkeys
        Break
    }
}
Return

ResetKeybinds:
KB_Copy        := ""
KB_Paste       := ""
KB_GrabSig     := ""
KB_SetRoot     := ""
KB_FormatEnf   := ""
KB_FinH        := ""
KB_Fin13       := ""
KB_Fin1        := ""
KB_Fin2        := ""
KB_Fin3        := ""
KB_Fin4        := ""
KB_Fin5        := ""
KB_Fin6        := ""
KB_FinETag     := ""
KB_FinSlash    := ""
KB_FinN        := ""
KB_FinL        := ""
KB_FinM        := ""
KB_FinS        := ""
KB_FinC        := ""
GoSub, SaveAllSettings
GoSub, RefreshHotkeys
GoSub, BuildMainGui
Return

ShowRootTooltip:
if (RootModeActive) {
    NextNumDisplay   := BuildSystemKey(RootKey, NextNum,   False)
    NextAlphaDisplay := BuildSystemKey(RootKey, NextAlpha, True)
    if (RootKey = "")
        TipText := "root: home mode`nnext num: " . NextNumDisplay . "  next alpha: " . NextAlphaDisplay
    else
        TipText := "root: " . RootKey . "`nnext num: " . NextNumDisplay . "  next alpha: " . NextAlphaDisplay
} else {
    TipText := "root: not set"
}
ToolTip, %TipText%
SetTimer, RemoveTooltip, -2500
Return

RemoveTooltip:
ToolTip
Return

RefreshHotkeys:
; Step 1: Disable ALL hotkeys in ALL contexts first
Hotkey, IfWinActive

; First, disable all hotkeys that might be registered (current ones)
For hk, lbl in HotkeyLabelMap
{
    if (hk != "")
        Hotkey, %hk%, Off, UseErrorLevel
}

; Step 2: Read all enabled windows
IniRead, EnabledSection, %IniFile%, Enabled

; Step 3: Create a list of all possible hotkey bindings (non-empty only)
AllPossibleBindings := []
if (KB_Copy != "")
    AllPossibleBindings.Insert(KB_Copy)
if (KB_Paste != "")
    AllPossibleBindings.Insert(KB_Paste)
if (KB_GrabSig != "")
    AllPossibleBindings.Insert(KB_GrabSig)
if (KB_SetRoot != "")
    AllPossibleBindings.Insert(KB_SetRoot)
if (KB_FormatEnf != "")
    AllPossibleBindings.Insert(KB_FormatEnf)
if (KB_FinH != "")
    AllPossibleBindings.Insert(KB_FinH)
if (KB_Fin13 != "")
    AllPossibleBindings.Insert(KB_Fin13)
if (KB_Fin1 != "")
    AllPossibleBindings.Insert(KB_Fin1)
if (KB_Fin2 != "")
    AllPossibleBindings.Insert(KB_Fin2)
if (KB_Fin3 != "")
    AllPossibleBindings.Insert(KB_Fin3)
if (KB_Fin4 != "")
    AllPossibleBindings.Insert(KB_Fin4)
if (KB_Fin5 != "")
    AllPossibleBindings.Insert(KB_Fin5)
if (KB_Fin6 != "")
    AllPossibleBindings.Insert(KB_Fin6)
if (KB_FinETag != "")
    AllPossibleBindings.Insert(KB_FinETag)
if (KB_FinSlash != "")
    AllPossibleBindings.Insert(KB_FinSlash)
if (KB_FinN != "")
    AllPossibleBindings.Insert(KB_FinN)
if (KB_FinL != "")
    AllPossibleBindings.Insert(KB_FinL)
if (KB_FinM != "")
    AllPossibleBindings.Insert(KB_FinM)
if (KB_FinS != "")
    AllPossibleBindings.Insert(KB_FinS)
if (KB_FinC != "")
    AllPossibleBindings.Insert(KB_FinC)

; Step 4: For each enabled window, clear all possible hotkeys
Loop, Parse, EnabledSection, `n, `r
{
    Line := Trim(A_LoopField)
    if (Line = "")
        continue
    EqPos := InStr(Line, "=")
    if (!EqPos)
        continue
    WinTitle := Trim(SubStr(Line, 1, EqPos - 1))
    
    Hotkey, IfWinActive, %WinTitle%
    
    ; Disable all possible hotkey variations for this window
    For index, binding in AllPossibleBindings
    {
        if (binding != "")
            Hotkey, %binding%, Off, UseErrorLevel
    }
}

; Step 5: Build the new label map (only non-empty bindings)
HotkeyLabelMap := {}
if (KB_Copy != "")
    HotkeyLabelMap[KB_Copy]      := "DoCopy"
if (KB_Paste != "")
    HotkeyLabelMap[KB_Paste]     := "DoPaste"
if (KB_GrabSig != "")
    HotkeyLabelMap[KB_GrabSig]   := "DoQ"
if (KB_SetRoot != "")
    HotkeyLabelMap[KB_SetRoot]   := "DoSemi"
if (KB_FormatEnf != "")
    HotkeyLabelMap[KB_FormatEnf] := "DoE"
if (KB_FinH != "")
    HotkeyLabelMap[KB_FinH]      := "DoY"
if (KB_Fin13 != "")
    HotkeyLabelMap[KB_Fin13]     := "DoO"
if (KB_Fin1 != "")
    HotkeyLabelMap[KB_Fin1]      := "Do1"
if (KB_Fin2 != "")
    HotkeyLabelMap[KB_Fin2]      := "Do2"
if (KB_Fin3 != "")
    HotkeyLabelMap[KB_Fin3]      := "Do3"
if (KB_Fin4 != "")
    HotkeyLabelMap[KB_Fin4]      := "Do4"
if (KB_Fin5 != "")
    HotkeyLabelMap[KB_Fin5]      := "Do5"
if (KB_Fin6 != "")
    HotkeyLabelMap[KB_Fin6]      := "Do6"
if (KB_FinETag != "")
    HotkeyLabelMap[KB_FinETag]   := "DoQuote"
if (KB_FinSlash != "")
    HotkeyLabelMap[KB_FinSlash]  := "DoComma"
if (KB_FinN != "")
    HotkeyLabelMap[KB_FinN]      := "DoDot"
if (KB_FinL != "")
    HotkeyLabelMap[KB_FinL]      := "DoP"
if (KB_FinM != "")
    HotkeyLabelMap[KB_FinM]      := "DoM"
if (KB_FinS != "")
    HotkeyLabelMap[KB_FinS]      := "DoS"
if (KB_FinC != "")
    HotkeyLabelMap[KB_FinC]      := "DoC"

; Step 6: Enable only the current hotkeys for enabled windows
Loop, Parse, EnabledSection, `n, `r
{
    Line := Trim(A_LoopField)
    if (Line = "")
        continue
    EqPos := InStr(Line, "=")
    if (!EqPos)
        continue
    WinTitle := Trim(SubStr(Line, 1, EqPos - 1))
    Val      := Trim(SubStr(Line, EqPos + 1))
    
    if (Val = "1") {
        Hotkey, IfWinActive, %WinTitle%
        For hk, lbl in HotkeyLabelMap
        {
            if (hk != "")
                Hotkey, %hk%, %lbl%, On, UseErrorLevel
        }
    }
}

; Step 7: Reset the hotkey context
Hotkey, IfWinActive
Return

BuildSystemKey(root, counter, isAlpha) {
    if (isAlpha)
        return root . Chr(64 + counter)
    else
        return root . counter
}

FindNextNum() {
    global UsedNums, NextNum
    while (UsedNums[NextNum])
        NextNum++
}

FindNextAlpha() {
    global UsedAlphas, NextAlpha
    while (UsedAlphas[NextAlpha])
        NextAlpha++
}

FireRootFinisher(finChar, isAlpha) {
    global RootKey, RootJustFired, LastSigId, LastFinisherWasAlpha
    global UsedNums, UsedAlphas, NextNum, NextAlpha
    global ReadyToIncrement, LastUsedNum, LastUsedAlpha

    if (isAlpha) {
        if (ReadyToIncrement) {
            ; Use next available and mark as used
            SysKey := BuildSystemKey(RootKey, NextAlpha, True)
            UsedAlphas[NextAlpha] := True
            LastUsedAlpha := NextAlpha
            FindNextAlpha()
        } else {
            ; Correct-in-place: reuse last used alpha
            if (LastUsedAlpha = "")
                LastUsedAlpha := NextAlpha
            SysKey := BuildSystemKey(RootKey, LastUsedAlpha, True)
        }
    } else {
        if (ReadyToIncrement) {
            ; Use next available and mark as used
            SysKey := BuildSystemKey(RootKey, NextNum, False)
            UsedNums[NextNum] := True
            LastUsedNum := NextNum
            FindNextNum()
        } else {
            ; Correct-in-place: reuse last used number
            if (LastUsedNum = "")
                LastUsedNum := NextNum
            SysKey := BuildSystemKey(RootKey, LastUsedNum, False)
        }
    }

    Result := SysKey . LastSigId . " " . finChar
    StringUpper, Result, Result
    Clipboard := Result
    ClipWait, 2

    if (!ReadyToIncrement) {
        Send ^a
        Sleep 50
    }

    Sleep 50
    Send ^v

    ReadyToIncrement     := False
    RootJustFired        := True
    LastFinisherWasAlpha := isAlpha
}

GetFirstField(line) {
    TabPos := InStr(line, "`t")
    if (TabPos > 0)
        return Trim(SubStr(line, 1, TabPos - 1))
    return Trim(line)
}

CountValidBookmarkLines(clip) {
    count := 0
    Loop, Parse, clip, `n, `r
    {
        Line := Trim(A_LoopField)
        if (Line = "")
            continue
        FirstField := GetFirstField(Line)
        if (FirstField = "")
            continue
        StringUpper, FirstField, FirstField
        HyphenPos := InStr(FirstField, "-")
        if (HyphenPos >= 2) {
            AfterHyphen := SubStr(FirstField, HyphenPos + 1)
            if (AfterHyphen ~= "^[A-Z]{3}")
                count++
        } else if (FirstField ~= "^[A-Z0-9]+$" && StrLen(FirstField) <= 10) {
            count++
        }
    }
    return count
}

AllPrefixesSingle(clip) {
    foundAny := False
    Loop, Parse, clip, `n, `r
    {
        Line := Trim(A_LoopField)
        if (Line = "")
            continue
        FirstField := GetFirstField(Line)
        if (FirstField = "")
            continue
        StringUpper, FirstField, FirstField
        HyphenPos := InStr(FirstField, "-")
        if (HyphenPos < 2)
            continue
        Prefix := SubStr(FirstField, 1, HyphenPos - 1)
        AfterHyphen := SubStr(FirstField, HyphenPos + 1)
        if (AfterHyphen ~= "^[A-Z]{3}") {
            foundAny := True
            if !(Prefix ~= "^[A-Z0-9]$")
                return False
        }
    }
    return foundAny
}

DoCopy:
Send ^c
Return

DoPaste:
Send ^v
Return

DoQ:
Send ^c
Sleep 100
ClipWait, 2
ClipSaved := Clipboard
ClipTrim := SubStr(ClipSaved, 1, 3)
Clipboard := "-" . ClipTrim . " "
LastSigId := "-" . ClipTrim
ReadyToIncrement := True
RootJustFired := False
Return

DoSemi:
Clipboard := ""
Send ^c
Sleep 100
ClipWait, 2, 1
ClipSaved := Clipboard
RootKey              := ""
RootJustFired        := False
LastFinisherWasAlpha := False
RootModeActive       := False
ZeroMode             := False
ReadyToIncrement     := False
UsedNums             := {}
UsedAlphas           := {}
NextNum              := 1
NextAlpha            := 1
LastUsedNum          := ""
LastUsedAlpha        := ""
if (ClipSaved = "") {
    RootModeActive := True
    GoSub, ShowRootTooltip
    Return
}
ValidCount := CountValidBookmarkLines(ClipSaved)
if (ValidCount > 1 && AllPrefixesSingle(ClipSaved)) {
    RootKey        := ""
    RootModeActive := True
    ZeroMode       := True
} else {
    Loop, Parse, ClipSaved, `n, `r
    {
        Line := Trim(A_LoopField)
        if (Line = "")
            continue
        FirstField := GetFirstField(Line)
        if (FirstField = "")
            continue
        StringUpper, FirstField, FirstField
        if (FirstField ~= "^[A-Z0-9]+$" && StrLen(FirstField) <= 10) {
            RootKey        := FirstField
            RootModeActive := True
            ZeroMode       := False
            Break
        }
        HyphenPos := InStr(FirstField, "-")
        if (HyphenPos < 2)
            continue
        Prefix      := SubStr(FirstField, 1, HyphenPos - 1)
        AfterHyphen := SubStr(FirstField, HyphenPos + 1)
        if (AfterHyphen ~= "^[A-Z]{3}") {
            RootKey        := Prefix
            RootModeActive := True
            ZeroMode       := False
            Break
        }
    }
}
if (!RootModeActive) {
    HyphenPos := InStr(ClipSaved, "-")
    if (HyphenPos > 1) {
        RootKey        := SubStr(ClipSaved, 1, HyphenPos - 1)
        StringUpper, RootKey, RootKey
        RootModeActive := True
        ZeroMode       := False
        Clipboard      := RootKey
    }
    GoSub, ShowRootTooltip
    Return
}
Loop, Parse, ClipSaved, `n, `r
{
    Line := Trim(A_LoopField)
    if (Line = "")
        continue
    FirstField := GetFirstField(Line)
    if (FirstField = "")
        continue
    HyphenPos := InStr(FirstField, "-")
    if (HyphenPos < 2)
        continue
    Prefix := SubStr(FirstField, 1, HyphenPos - 1)
    StringUpper, Prefix, Prefix
    if (ZeroMode) {
        if (Prefix ~= "^\d$")
            UsedNums[Prefix + 0] := True
        else if (Prefix ~= "^[A-Z]$")
            UsedAlphas[Asc(Prefix) - 64] := True
    } else {
        if (SubStr(Prefix, 1, StrLen(RootKey)) != RootKey)
            continue
        KeySuffix := SubStr(Prefix, StrLen(RootKey) + 1)
        if (KeySuffix = "")
            continue
        if (KeySuffix ~= "^\d+$")
            UsedNums[KeySuffix + 0] := True
        else if (KeySuffix ~= "^[A-Z]$")
            UsedAlphas[Asc(KeySuffix) - 64] := True
    }
}
FindNextNum()
FindNextAlpha()
Clipboard := RootKey
GoSub, ShowRootTooltip
Return

DoE:
NewSuffix := ""
NewE := 0
NewSlash := 0
NewM := 0
NewS := 0
NewC := 0
GoSub, ReadField
StringUpper, ClipUpper, ClipRaw
GoSub, FormatClipAndPaste
Return

DoY:
if (RootModeActive) {
    FinChar := GetKeyState("CapsLock", "T") ? "h" : "H"
    FireRootFinisher(FinChar, True)
} else {
    GoSub, ReadField
    StringUpper, ClipUpper, ClipRaw
    NewSuffix := GetKeyState("CapsLock", "T") ? "h" : "H"
    NewE := 0
    NewSlash := 0
    NewM := 0
    NewS := 0
    NewC := 0
    GoSub, FormatClipAndPaste
}
Return

DoO:
if (RootModeActive) {
    FireRootFinisher("13", False)
} else {
    GoSub, ReadField
    StringUpper, ClipUpper, ClipRaw
    NewSuffix := "13"
    NewE := 0
    NewSlash := 0
    NewM := 0
    NewS := 0
    NewC := 0
    GoSub, FormatClipAndPaste
}
Return

DoP:
if (RootModeActive) {
    FinChar := GetKeyState("CapsLock", "T") ? "l" : "L"
    FireRootFinisher(FinChar, True)
} else {
    GoSub, ReadField
    StringUpper, ClipUpper, ClipRaw
    NewSuffix := GetKeyState("CapsLock", "T") ? "l" : "L"
    NewE := 0
    NewSlash := 0
    NewM := 0
    NewS := 0
    NewC := 0
    GoSub, FormatClipAndPaste
}
Return

DoDot:
if (RootModeActive) {
    FinChar := GetKeyState("CapsLock", "T") ? "n" : "N"
    FireRootFinisher(FinChar, True)
} else {
    GoSub, ReadField
    StringUpper, ClipUpper, ClipRaw
    NewSuffix := GetKeyState("CapsLock", "T") ? "n" : "N"
    NewE := 0
    NewSlash := 0
    NewM := 0
    NewS := 0
    NewC := 0
    GoSub, FormatClipAndPaste
}
Return

DoM:
GoSub, ReadField
StringUpper, ClipUpper, ClipRaw
NewSuffix := ""
NewE := 0
NewSlash := 0
NewM := 1
NewS := 0
NewC := 0
GoSub, FormatClipAndPaste
Return

DoS:
GoSub, ReadField
StringUpper, ClipUpper, ClipRaw
NewSuffix := ""
NewE := 0
NewSlash := 0
NewM := 0
NewS := 1
NewC := 0
GoSub, FormatClipAndPaste
Return

DoC:
GoSub, ReadField
StringUpper, ClipUpper, ClipRaw
NewSuffix := ""
NewE := 0
NewSlash := 0
NewM := 0
NewS := 0
NewC := 1
GoSub, FormatClipAndPaste
Return

Do1:
if (RootModeActive) {
    FireRootFinisher("1", False)
} else {
    GoSub, ReadField
    StringUpper, ClipUpper, ClipRaw
    NewSuffix := "1"
    NewE := 0
    NewSlash := 0
    NewM := 0
    NewS := 0
    NewC := 0
    GoSub, FormatClipAndPaste
}
Return

Do2:
if (RootModeActive) {
    FireRootFinisher("2", False)
} else {
    GoSub, ReadField
    StringUpper, ClipUpper, ClipRaw
    NewSuffix := "2"
    NewE := 0
    NewSlash := 0
    NewM := 0
    NewS := 0
    NewC := 0
    GoSub, FormatClipAndPaste
}
Return

Do3:
if (RootModeActive) {
    FireRootFinisher("3", False)
} else {
    GoSub, ReadField
    StringUpper, ClipUpper, ClipRaw
    NewSuffix := "3"
    NewE := 0
    NewSlash := 0
    NewM := 0
    NewS := 0
    NewC := 0
    GoSub, FormatClipAndPaste
}
Return

Do4:
if (RootModeActive) {
    FireRootFinisher("4", False)
} else {
    GoSub, ReadField
    StringUpper, ClipUpper, ClipRaw
    NewSuffix := "4"
    NewE := 0
    NewSlash := 0
    NewM := 0
    NewS := 0
    NewC := 0
    GoSub, FormatClipAndPaste
}
Return

Do5:
if (RootModeActive) {
    FireRootFinisher("5", False)
} else {
    GoSub, ReadField
    StringUpper, ClipUpper, ClipRaw
    NewSuffix := "5"
    NewE := 0
    NewSlash := 0
    NewM := 0
    NewS := 0
    NewC := 0
    GoSub, FormatClipAndPaste
}
Return

Do6:
if (RootModeActive) {
    FireRootFinisher("6", False)
} else {
    GoSub, ReadField
    StringUpper, ClipUpper, ClipRaw
    NewSuffix := "6"
    NewE := 0
    NewSlash := 0
    NewM := 0
    NewS := 0
    NewC := 0
    GoSub, FormatClipAndPaste
}
Return

DoQuote:
GoSub, ReadField
StringUpper, ClipUpper, ClipRaw
NewSuffix := ""
NewE := 1
NewSlash := 0
NewM := 0
NewS := 0
NewC := 0
GoSub, FormatClipAndPaste
Return

DoComma:
GoSub, ReadField
StringUpper, ClipUpper, ClipRaw
NewSuffix := ""
NewE := 0
NewSlash := 1
NewM := 0
NewS := 0
NewC := 0
GoSub, FormatClipAndPaste
Return

ReadField:
Clipboard := ""
Send ^a
Sleep 50
Send ^c
ClipWait, 2
ClipRaw := Clipboard
Return

FormatClipAndPaste:
global NewM, NewS, NewC
Raw := ClipUpper
DashPos := InStr(Raw, "-")
if (DashPos > 0) {
    Prefix := SubStr(Raw, 1, DashPos - 1)
    Rest   := SubStr(Raw, DashPos + 1)
    CleanPrefix := ""
    Loop, Parse, Prefix
    {
        c := A_LoopField
        if (c >= "A" && c <= "Z") || (c >= "0" && c <= "9")
            CleanPrefix .= c
    }
    SysCode      := ""
    RestAfterSys := Rest
    Loop, Parse, Rest
    {
        c := A_LoopField
        if (StrLen(SysCode) < 3) && (c >= "A" && c <= "Z")
            SysCode .= c
        else {
            RestAfterSys := SubStr(Rest, A_Index)
            break
        }
    }
    Base := CleanPrefix . "-" . SysCode
} else {
    Clipboard := Raw
    ClipWait, 2
    Send ^v
    NewSuffix := ""
    NewE      := 0
    NewSlash  := 0
    NewM      := 0
    NewS      := 0
    NewC      := 0
    Return
}
RestAfterSys := RegExReplace(RestAfterSys, "^\s+", "")
ExistingE      := 0
ExistingSlash  := 0
ExistingM      := 0
ExistingS      := 0
ExistingC      := 0
ExistingSuffix := ""
Tokens := StrSplit(RestAfterSys, " ")
Loop % Tokens.MaxIndex()
{
    t := Tokens[A_Index]
    if (t = "13" || (StrLen(t) = 1 && (t >= "1" && t <= "6" || t = "H" || t = "L" || t = "N" || t = "T" || t = "D")))
        ExistingSuffix := t
    else if (t = "E")
        ExistingE := 1
    else if (t = "/")
        ExistingSlash := 1
    else if (t = "M")
        ExistingM := 1
    else if (t = "S")
        ExistingS := 1
    else if (t = "C")
        ExistingC := 1
}

; Apply mutual exclusivity rules
; S and M are mutually exclusive (if setting one, clear the other)
if (NewM) {
    NewS := 0
}
if (NewS) {
    NewM := 0
}

; / and C are mutually exclusive (if setting one, clear the other)
if (NewSlash) {
    NewC := 0
}
if (NewC) {
    NewSlash := 0
}

FinalSuffix := (NewSuffix != "") ? NewSuffix : ExistingSuffix

; Apply mutual exclusivity to final tags
; For M/S: if both are set from existing, prefer the new one if being set
if (NewM) {
    FinalM := 1
    FinalS := 0
} else if (NewS) {
    FinalM := 0
    FinalS := 1
} else {
    ; Neither is being set new, keep existing but ensure mutual exclusivity
    if (ExistingM && ExistingS) {
        ; This shouldn't happen normally, but if both exist, prefer S over M
        FinalM := 0
        FinalS := 1
    } else {
        FinalM := ExistingM
        FinalS := ExistingS
    }
}

; For / and C: if both are set from existing, prefer the new one if being set
if (NewSlash) {
    FinalSlash := 1
    FinalC := 0
} else if (NewC) {
    FinalSlash := 0
    FinalC := 1
} else {
    ; Neither is being set new, keep existing but ensure mutual exclusivity
    if (ExistingSlash && ExistingC) {
        ; This shouldn't happen normally, but if both exist, prefer C over /
        FinalSlash := 0
        FinalC := 1
    } else {
        FinalSlash := ExistingSlash
        FinalC := ExistingC
    }
}

; E can stack with anything, no mutual exclusivity needed
FinalE := (ExistingE || NewE)

Result := Base
if (FinalSuffix != "")
    Result .= " " . FinalSuffix
if (FinalE)
    Result .= " E"
if (FinalSlash)
    Result .= " /"
if (FinalM)
    Result .= " M"
if (FinalS)
    Result .= " S"
if (FinalC)
    Result .= " C"
Clipboard := Result
ClipWait, 2
Sleep 50
Send ^v
NewSuffix := ""
NewE      := 0
NewSlash  := 0
NewM      := 0
NewS      := 0
NewC      := 0
Return