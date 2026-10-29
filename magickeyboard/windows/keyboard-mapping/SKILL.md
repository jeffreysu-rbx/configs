---
name: keyboard-mapping
description: >
  Switch the Windows keyboard remap between the Apple Magic Keyboard layout and the
  normal Windows layout. Use when the user says "mac keyboard mode", "switch to magic
  keyboard", "windows keyboard mode", "reverse the mapping", "undo the keyboard remap",
  or asks which keyboard mapping is active. Args: `mac`, `windows`, or `status`.
---

# Keyboard mapping (SharpKeys / Scancode Map)

The remap is the `Scancode Map` registry value that SharpKeys writes:
`HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout`. It applies to **all**
keyboards and only takes effect after a **sign-out or restart**.

| Mode | File | Effect |
|---|---|---|
| `mac` | `mac.reg` | Caps Lock → Ctrl, Command ↔ Option (Command → Alt, Option → Win), both sides |
| `windows` | `windows.reg` | Deletes `Scancode Map` (stock Windows behavior) |

Files live in this skill's directory: `%USERPROFILE%\.claude\skills\keyboard-mapping\`.

## Steps

1. **Status** — always check first:
   ```bash
   reg query "HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout" //v "Scancode Map" 2>&1
   ```
   - Value `0000000000000000060000001D003A0038005BE05BE0380038E05CE05CE038E000000000` → `mac` mode.
   - "unable to find" error → `windows` mode.
   - Anything else → a custom SharpKeys mapping. Show it to the user and ask before overwriting.

   If the arg is `status` (or none given), report the mode and stop.
   If the requested mode is already active, say so and stop.

2. **Apply** — writing HKLM needs admin, so import elevated (the user approves a UAC prompt):
   ```bash
   powershell -NoProfile -Command "Start-Process reg.exe -ArgumentList 'import','\"$(cygpath -w ~/.claude/skills/keyboard-mapping/<mode>.reg)\"' -Verb RunAs -Wait"
   ```
   Replace `<mode>` with `mac` or `windows`.

3. **Verify** — rerun the status query and confirm the value matches the requested mode.
   If it didn't change, or step 2 printed "Access is denied", elevation was declined or
   blocked. Do **not** try other ways to elevate. Tell the user to apply it themselves:
   double-click `<mode>.reg` in File Explorer and accept the prompts, or open SharpKeys
   (it shows the current mappings; use "Delete All" for `windows` mode) and click
   "Write to Registry". Then rerun the status query.

4. **Tell the user to sign out or restart.** Do not restart or sign out for them.
