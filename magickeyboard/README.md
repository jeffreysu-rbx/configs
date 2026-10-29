# Apple Magic Keyboard on Windows

Makes an Apple Magic Keyboard behave like it does on a Mac.

## Files

| File | What it does |
|---|---|
| `windows/keyboard-mapping/mac.reg` | Remaps keys at the scancode level (same value SharpKeys writes): Caps Lock → Ctrl, Command → Alt, Option → Win, both sides. Applies to **all** keyboards. |
| `windows/keyboard-mapping/windows.reg` | Removes the remap (stock Windows layout). |
| `windows/keyboard-mapping/SKILL.md` | Claude Code skill that switches between the two `.reg` files (`/keyboard-mapping mac`, `windows`, or `status`). |
| `windows/cmd-tab.ahk` | AutoHotkey v2 script for Mac shortcuts the remap alone can't give you. Currently: Cmd+A → select all. |

Command → Alt means Cmd+Tab already switches windows natively. Because the remap
happens before AutoHotkey sees the key, Cmd+<key> arrives in the script as
Alt+<key>, so hotkeys are written as `!<key>`.

## Setup

1. **Install the skill** so the `.reg` files sit where `SKILL.md` expects them:

   ```bash
   mkdir -p ~/.claude/skills && cp -r windows/keyboard-mapping ~/.claude/skills/
   ```

2. **Apply the remap.** Either ask Claude Code for "mac keyboard mode", or
   double-click `mac.reg` and accept the UAC and Registry Editor prompts.
   Then **sign out or restart**; the remap only takes effect at sign-in.

   To check it: `reg query "HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout" //v "Scancode Map"`

3. **Install [AutoHotkey v2](https://www.autohotkey.com/)** and copy the script
   next to the skill:

   ```bash
   cp windows/cmd-tab.ahk ~/.claude/skills/keyboard-mapping/
   ```

4. **Run the script at login** by adding a shortcut to it in the Startup folder
   (open with Win+R → `shell:startup`), or from Git Bash:

   ```bash
   powershell -NoProfile -Command "\$s = (New-Object -ComObject WScript.Shell).CreateShortcut(\"\$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\cmd-tab.ahk.lnk\"); \$s.TargetPath = \"\$env:USERPROFILE\.claude\skills\keyboard-mapping\cmd-tab.ahk\"; \$s.Save()"
   ```

   Double-click `cmd-tab.ahk` to start it now without signing out.

## Switching back to a normal keyboard

Ask Claude Code for "windows keyboard mode", or double-click `windows.reg`, then
sign out. Also quit `cmd-tab.ahk` (tray icon → Exit) and remove its Startup
shortcut: without the remap, Command is the Win key again, so the script would
take over the real Alt+A.

## Adding shortcuts

Add one line per shortcut to `cmd-tab.ahk`, then reload it (tray icon → Reload Script):

```ahk
!c::Send "^c"   ; Cmd+C → copy
!v::Send "^v"   ; Cmd+V → paste
```
