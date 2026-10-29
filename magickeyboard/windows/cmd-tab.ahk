#Requires AutoHotkey v2.0
#SingleInstance Force

; Pairs with mac.reg: Command is remapped to Alt at the scancode level,
; so Cmd+<key> arrives here as Alt+<key>.

!a::Send "^a"   ; Cmd+A → Ctrl+A (select all)
