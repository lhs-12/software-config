local wezterm = require("wezterm")
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end
-- Win Config
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	local git_bash = { "C:/Program Files/Git/bin/bash.exe", "-l", "-i" }
	config.default_prog = git_bash
	config.launch_menu = {
		{ label = "Git Bash", args = git_bash },
		{ label = "CMD", args = { "cmd.exe" } },
		{ label = "PowerShell", args = { "powershell.exe" } },
		{ label = "WSL", args = { "wsl.exe", "--cd", "/home" } },
	}
	config.win32_system_backdrop = "Acrylic"
	config.background = {
		{
			source = { File = "C:/Users/L/Pictures/wez.jpg" },
			opacity = 0.8,
			hsb = { brightness = 0.05, hue = 0.5, saturation = 0.5 },
		},
	}
end
-- Tab Bar
config.enable_tab_bar = true
wezterm.on("format-tab-title", function(tab, tabs)
	local pane = tab.active_pane
	local index = ""
	if #tabs > 1 then
		index = string.format("%d: ", tab.tab_index + 1)
	end
	local process = string.gsub(pane.foreground_process_name, "(.*[/\\])(.*)", "%2")
	return { { Text = " " .. index .. process .. " " } }
end)
-- Window
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"
config.enable_scroll_bar = true
config.initial_cols = 120
config.initial_rows = 35
config.window_padding = { left = 4, right = 10, top = 1, bottom = 1 }
local my_scheme = wezterm.color.get_builtin_schemes()["3024 (base16)"]
my_scheme.ansi[5] = "navy"
config.color_schemes = { ["my_scheme"] = my_scheme }
config.color_scheme = "my_scheme"
-- Font
config.font_size = 12.0
config.adjust_window_size_when_changing_font_size = false
config.default_cursor_style = "SteadyUnderline"
config.font = wezterm.font_with_fallback({
	"JetBrainsMono Nerd Font",
	"Sarasa Mono SC",
})
-- Keys
config.disable_default_key_bindings = false
config.use_dead_keys = false
local act = wezterm.action
config.keys = {
	{ mods = "CTRL|SHIFT", key = "j", action = act.ActivatePaneDirection("Next") },
}
return config
