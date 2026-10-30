# Apple Magic Keyboard on Windows

Makes an Apple Magic Keyboard behave like it does on a Mac.

## Files

| File | What it does |
|---|---|
| `windows/keyboard-mapping/mac.reg` | Remaps keys at the scancode level (same value SharpKeys writes): Caps Lock → Ctrl, Command → Alt, Option → Win, both sides. Applies to **all** keyboards. |
| `windows/keyboard-mapping/windows.reg` | Removes the remap (stock Windows layout). |
| `windows/keyboard-mapping/SKILL.md` | Claude Code skill that switches between the two `.reg` files (`/keyboard-mapping mac`, `windows`, or `status`). |
| `windows/cmd-tab.ahk` | AutoHotkey v2 script for Mac shortcuts the remap alone can't give you. Currently: Cmd+A → select all, and in Rider, Option+Cmd+←/→ → navigate back/forward. |
| `windows/rider/IntelliJ (Magic Keyboard).xml` | Rider keymap based on the IntelliJ defaults that adds Cmd+L → go to line and Cmd+click → go to declaration. |

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

5. **(Optional) Install the Rider keymap**, then restart Rider and select
   "IntelliJ (Magic Keyboard)" in Settings → Keymap:

   ```bash
   mkdir -p "$APPDATA/JetBrains/Rider2026.1/keymaps" && cp windows/rider/*.xml "$APPDATA/JetBrains/Rider2026.1/keymaps/"
   ```

   Change `Rider2026.1` to match your Rider version. The keymap gives Alt+click
   to go to declaration, so column selection moves to middle-click drag and the
   debugger's Alt+click quick evaluate is removed (Ctrl+Alt+F8 still works).
   Option+Cmd+←/→ can't live in the keymap because Option is the Win key, which
   Rider can't bind; `cmd-tab.ahk` handles it instead.

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
