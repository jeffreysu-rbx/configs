# WezTerm (Windows)

Adapted from [kunchenguid/dotfiles](https://github.com/kunchenguid/dotfiles/blob/main/home/.config/wezterm/wezterm.lua) for Windows.

## Install

1. Install [Hack Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip)
   (falls back to Cascadia Mono if missing).
2. Copy the config to either location WezTerm reads on Windows:
   - `%USERPROFILE%\.config\wezterm\wezterm.lua`
   - `%USERPROFILE%\.wezterm.lua`

   ```bash
   mkdir -p ~/.config/wezterm && cp .config/wezterm/wezterm.lua ~/.config/wezterm/
   ```

## Windows-specific changes

- Default shell is Git Bash (`C:\Program Files\Git\bin\bash.exe -l`).
- `win32_system_backdrop = "Acrylic"` instead of `macos_window_background_blur`.
- Font size 11.5 (≈ 15pt on macOS).
- Tab bar always shown with integrated min/max/close buttons, so it works as a
  draggable title bar. Ctrl+Shift+drag also moves the window.
- Ctrl+C copies when there's a selection (otherwise interrupts), Ctrl+V pastes,
  Ctrl+T new tab, Ctrl+W close tab.
