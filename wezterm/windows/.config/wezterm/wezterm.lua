-- Adapted from https://github.com/kunchenguid/dotfiles/blob/main/home/.config/wezterm/wezterm.lua
-- for Windows.
local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder()

-- Open Git Bash as a login shell by default
config.default_prog = { "C:\\Program Files\\Git\\bin\\bash.exe", "-l" }

config.color_scheme = "rose-pine-moon"
-- Fall back to Cascadia Mono (ships with Windows 11) if Hack Nerd Font goes missing.
config.font = wezterm.font_with_fallback({ "Hack Nerd Font", "Cascadia Mono" })
-- macOS renders points at 72 DPI and Windows at 96, so 15pt on a Mac looks
-- roughly like 11-12pt here.
config.font_size = 11.5
config.window_background_opacity = 0.8
-- Windows equivalent of macos_window_background_blur: frosted-glass backdrop.
config.win32_system_backdrop = "Acrylic"
-- Put minimize/maximize/close in the tab bar and always show it, so it doubles as
-- a title bar: drag the empty space to move, double-click to maximize.
config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
config.hide_tab_bar_if_only_one_tab = false
-- Match the title bar to rose-pine-moon instead of the default gray.
config.window_frame = {
	font = wezterm.font("Hack Nerd Font", { weight = "Bold" }),
	font_size = 10.0,
	active_titlebar_bg = "#232136",
	inactive_titlebar_bg = "#232136",
}

-- Ctrl+Shift+drag anywhere in the window also moves it.
config.mouse_bindings = {
	{
		event = { Drag = { streak = 1, button = "Left" } },
		mods = "CTRL|SHIFT",
		action = act.StartWindowDrag,
	},
}

config.keys = {
	-- Ctrl+C copies if there is a selection, otherwise sends Ctrl+C (interrupt)
	{
		key = "c",
		mods = "CTRL",
		action = wezterm.action_callback(function(window, pane)
			local selection = window:get_selection_text_for_pane(pane)
			if selection ~= "" then
				window:perform_action(act.CopyTo("Clipboard"), pane)
				window:perform_action(act.ClearSelection, pane)
			else
				window:perform_action(act.SendKey({ key = "c", mods = "CTRL" }), pane)
			end
		end),
	},
	-- Ctrl+V pastes from the clipboard
	{ key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },
	-- Ctrl+W closes the current tab (asks for confirmation if a process is running)
	{ key = "w", mods = "CTRL", action = act.CloseCurrentTab({ confirm = true }) },
	-- Ctrl+T opens a new tab
	{ key = "t", mods = "CTRL", action = act.SpawnTab("CurrentPaneDomain") },
}

-- Dim unfocused windows so the focused one is obvious at a glance.
local UNFOCUSED_FOREGROUND_TEXT_HSB = { hue = 1.0, saturation = 0.25, brightness = 0.45 }
local UNFOCUSED_WINDOW_BACKGROUND_OPACITY = 0.62

-- get_config_overrides() hands back a copy, so the current value is never the
-- same table we last stored; compare the fields instead of the identity.
local function same_text_hsb(actual, expected)
	if actual == nil or expected == nil then
		return actual == expected
	end
	return actual.hue == expected.hue
		and actual.saturation == expected.saturation
		and actual.brightness == expected.brightness
end

wezterm.on("window-focus-changed", function(window)
	local overrides = window:get_config_overrides() or {}
	local text_hsb, opacity
	if not window:is_focused() then
		text_hsb = UNFOCUSED_FOREGROUND_TEXT_HSB
		opacity = UNFOCUSED_WINDOW_BACKGROUND_OPACITY
	end

	-- Only write when one of the two values we own actually changes; a redundant
	-- set_config_overrides() call would trigger another config reload.
	if same_text_hsb(overrides.foreground_text_hsb, text_hsb) and overrides.window_background_opacity == opacity then
		return
	end

	overrides.foreground_text_hsb = text_hsb
	overrides.window_background_opacity = opacity
	window:set_config_overrides(overrides)
end)

return config
