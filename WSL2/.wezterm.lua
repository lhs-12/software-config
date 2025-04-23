local wezterm = require("wezterm")
local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end
local act = wezterm.action
-- lanuch bash by default
-- config.default_prog = { "/usr/bin/bash", "-l" }
config.detect_password_input = true
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"
config.enable_tab_bar = true
config.initial_cols = 120
config.initial_rows = 35
config.window_padding = { left = 4, right = 1, top = 1, bottom = 1 }
config.color_scheme = "3024 (base16)"
config.default_cursor_style = "SteadyUnderline"
config.font = wezterm.font_with_fallback({
	"JetBrainsMono Nerd Font",
	"Sarasa Mono SC",
})
config.font_size = 12.0
config.adjust_window_size_when_changing_font_size = false
config.win32_system_backdrop = "Acrylic"
config.background = {{
    source = { File = "C:/Users/L/Pictures/Camera Roll/06.jpg" },
    height = "Cover",
    opacity = 0.5,
    hsb = { brightness = 0.05, hue = 0.5, saturation = 0.5 }
}}
config.keys = {{
	mods = "CTRL|SHIFT",
	key = "j",
	action = act.ActivatePaneDirection("Next")
}}
return config
