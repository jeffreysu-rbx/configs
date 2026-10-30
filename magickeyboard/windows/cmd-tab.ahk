#Requires AutoHotkey v2.0
#SingleInstance Force

; Pairs with mac.reg: Command is remapped to Alt at the scancode level,
; so Cmd+<key> arrives here as Alt+<key>.

!a::Send "^a"   ; Cmd+A → Ctrl+A (select all)

; Option is remapped to Win, which Rider can't bind, so translate Option+Cmd+arrows
; to Rider's IntelliJ keymap Back/Forward.
#HotIf WinActive("ahk_exe rider64.exe")
#!Left::Send "^!{Left}"     ; Option+Cmd+← → Navigate Back
#!Right::Send "^!{Right}"   ; Option+Cmd+→ → Navigate Forward
#HotIf
