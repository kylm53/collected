#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;CapsLock + jkhl (下上左右)，$(end), 0(home), d(delete), f(PageDown), b(PageUp), g(Document Head), e(Document End)
CapsLock & j::
    Send {Down}
Return
CapsLock & k::
    Send {Up}
Return
CapsLock & h::
    Send {Left}
Return
CapsLock & l::
    Send {Right}
Return
CapsLock & $::
    Send {End}
Return
CapsLock & 0::
    Send {Home}
Return
CapsLock & f::
    Send {PgDn}
Return
CapsLock & b::
    Send {PgUp}
Return
CapsLock & g::
    Send ^{Home}
Return
CapsLock & e::
    Send ^{End}
Return
CapsLock & d::
    Send {Delete}
Return

; Pointofix 屏幕画笔
!B::
    Process, Exist, Pointofix.exe
    NewPID := ErrorLevel
    if not NewPID
    {
        Run, D:\pointofix180de-20180511\Pointofix.exe
        sleep 200
        WinActivate, ahk_class TToolForm
        Send, {F9}
    } 
    else
        if WinExist("ahk_class TToolForm") 
        {
            ControlGetText, ButtonText, TButton1
            if not WinActive()
            {
                WinActivate
            }
            Send, {F9}

            if (ButtonText == "退出"){
                ; WinHide
                WinKill
            }
        }
        else
        {
            WinShow, ahk_class TToolForm
            WinActivate, ahk_class TToolForm
            Send, {F9}
        }
Return

; ctrl + space 补全
#If WinActive("ahk_exe studio64.exe") || WinActive("ahk_exe Code.exe")
    ;#IfWinActive ahk_exe studio64.exe || Code.exe
#UseHook, On
^Space::
    SetFormat, Integer, H
        WinGet, WinID,, A
    ThreadID:=DllCall("GetWindowThreadProcessId", "UInt", WinID, "UInt", 0)
    InputLocaleID:=DllCall("GetKeyboardLayout", "UInt", ThreadID, "UInt")
    
    ; 英语键盘
    if InputLocaleID = 0x4090409
    {
        Send, ^{Space}
        Return
    }
    else
    {
        ; 中文键盘切换为英文键盘
        Send, #{Space}
        sleep 100
        Send, ^{Space}
        sleep 100
        Send, #{Space}
    }
    ; 中文键盘切换为英文键盘
    Send, #{Space}
    sleep 100
    Send, ^{Space}
Return
#UseHook, Off

; git 缩写
#IfWinActive ahk_class mintty
    :*:gt::git status
    :*:gco::git checkout
    :*:gbr::git branch
    :*:gad::git add
    :*:glog::git log --oneline
Return

#IfWinActive ahk_exe chrome.exe
^!f::
    sleep 500
    Click, 135, 90
    sleep 500
    Send, ^+{Click, 230, 120}
    ; 等待网页加载完
    PixelGetColor, color, 700, 655
    ExpectColor := 0x11A472
    while (color != ExpectColor) {
        sleep 500
        PixelGetColor, color, 700, 655
    }
    Click, 700, 655
    sleep 1500
    MouseMove, 1080, 807
    sleep 500
    Click, 1080, 807
    ; 加载二维码
    PixelGetColor, color, 606, 600
    while (color != 0x000000) {
        sleep 500
        PixelGetColor, color, 606, 600
    }
    ; 右击v2RayN
    Click, right 1196, 886
    sleep 500
    ; 扫描二维码
    Click, 1080, 816
    sleep 1000
    ; 确定
    Send {Enter}
    ; 删除无效的服务器
    Send {Down} {Down}
    Send {Enter}
    Send {Down} {Up} {Delete}
    Send {Enter}
    ; 关闭v2RayN
    Send !{F4}
    sleep 1000
    ; 关闭 ishadow 标签
    Send ^w
Return
