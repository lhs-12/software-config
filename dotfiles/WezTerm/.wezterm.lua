local wezterm = require("wezterm")
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end
-- Linux Config
if wezterm.target_triple == "x86_64-unknown-linux-gnu" then
	config.background = {
		{
			source = { File = os.getenv("HOME") .. "/Pictures/Wallpapers/01.jpg" },
			hsb = { brightness = 0.05, hue = 0.5, saturation = 0.5 },
		},
	}
	config.default_prog = { "fish" }
	config.launch_menu = {
		{ label = "Bash", args = { "bash" } },
		{ label = "Fish", args = { "fish" } },
	}
	config.mouse_bindings = {
		{
			event = { Down = { streak = 1, button = { WheelUp = 1 } } },
			mods = "NONE",
			action = wezterm.action.ScrollByLine(-5),
			alt_screen = false,
		},
		{
			event = { Down = { streak = 1, button = { WheelDown = 1 } } },
			mods = "NONE",
			action = wezterm.action.ScrollByLine(5),
			alt_screen = false,
		},
	}
end
-- Win Config
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	-- local msys2 = { "cmd.exe", "/k", "C:\\msys64\\msys2_shell.cmd -defterm -here -no-start -ucrt64 -shell bash", "-l", "-i" }
	local msys2 = { "C:\\msys64\\msys2_shell.cmd", "-defterm", "-here", "-no-start", "-ucrt64" }
	config.default_prog = msys2
	config.launch_menu = {
		{ label = "Bash", args = msys2 },
		{ label = "CMD", args = { "cmd.exe" } },
		{ label = "PowerShell", args = { "powershell.exe" } },
		{ label = "WSL", args = { "wsl.exe", "--cd", "/home" } },
	}
	config.win32_system_backdrop = "Acrylic"
	config.background = {
		{
			source = { File = os.getenv("HOMEPATH") .. "/Pictures/Camera Roll/01.jpg" },
			opacity = 0.85,
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
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():set_position(400, 200)
end)
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"
config.enable_scroll_bar = true
config.initial_cols = 120
config.initial_rows = 35
config.window_padding = { left = 4, right = 12, top = 1, bottom = 1 }
local my_scheme = wezterm.color.get_builtin_schemes()["3024 (base16)"]
my_scheme.ansi[5] = "#33bcff"
config.color_schemes = { ["my_scheme"] = my_scheme }
config.color_scheme = "my_scheme"
config.colors = { scrollbar_thumb = "#404040" }
-- Font
config.font_size = 12.0
config.adjust_window_size_when_changing_font_size = false
config.default_cursor_style = "SteadyUnderline"
config.font = wezterm.font_with_fallback({
	-- "Maple Mono NF CN",
	-- "Maple Mono Normal NL NF CN",
	"Iosevka Term",
	"MiSans",
	{ family = "Symbols Nerd Font Mono", scale = 0.9 },
	"MiSans L3",
	"Noto Color Emoji",
})
-- Keys
config.disable_default_key_bindings = false
config.use_dead_keys = false
local act = wezterm.action
config.keys = {
	{ mods = "CTRL|SHIFT", key = "w", action = act.CloseCurrentTab({ confirm = false }) },
	{ mods = "CTRL|SHIFT", key = "j", action = act.ActivatePaneDirection("Next") },
}
return config
