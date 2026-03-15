local wezterm = require("wezterm")
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end
config.front_end = "WebGpu"
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
-- Microsoft Windows Config
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
	wezterm.on("gui-startup", function(cmd)
		local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
		window:gui_window():set_position(400, 200)
	end)
end
-- Tab Bar
config.enable_tab_bar = true
wezterm.on("format-tab-title", function(tab, tabs)
	local pane = tab.active_pane
	local title = (tab.tab_title ~= "" and tab.tab_title) or pane.foreground_process_name:match("([^/\\]+)$")
	local index = (#tabs > 1 and (tab.tab_index + 1) .. ":") or ""
	return { { Text = " " .. index .. title .. " " } }
end)
-- Window
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
if wezterm.target_triple == "x86_64-unknown-linux-gnu" then -- Fix Linux Bug
	config.window_decorations = "NONE"
	config.hide_tab_bar_if_only_one_tab = true
	config.tab_bar_at_bottom = true
	config.use_fancy_tab_bar = false
end
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
config.disable_default_key_bindings = true
config.use_dead_keys = false
local act = wezterm.action
-- stylua: ignore
config.keys = {
	-- ===== 命令面板 =====
	{ mods = "CTRL|SHIFT", key = "p", action = act.ActivateCommandPalette }, -- 打开命令面板
	-- ===== 最大化 =====
	{ mods = 'CTRL|SHIFT', key = 'F11', action = act.ToggleFullScreen },
	-- ===== 搜索 =====
	{ mods = "CTRL|SHIFT", key = "f", action = act.Search({ CaseSensitiveString = "" }) }, -- 搜索终端历史
	-- ===== 选择 / 复制 =====
	{ mods = "CTRL|SHIFT", key = "c"    , action = act.CopyTo("Clipboard")    }, -- 复制
	{ mods = "CTRL|SHIFT", key = "v"    , action = act.PasteFrom("Clipboard") }, -- 粘贴
	{ mods = "CTRL|SHIFT", key = "Space", action = act.QuickSelect            }, -- 快速复制 URL / 文件名等文本
	{ mods = "CTRL|SHIFT", key = "x"    , action = act.ActivateCopyMode       }, -- 进入复制模式
	-- ===== 滚动 =====
	{ mods = "CTRL|SHIFT", key = "PageUp", action = act.ScrollByPage(-1)  }, -- 向上滚动一页
	{ mods = "CTRL|SHIFT", key = "PageDown", action = act.ScrollByPage(1) }, -- 向下滚动一页
	{ mods = "CTRL|SHIFT", key = "Home", action = act.ClearScrollback("ScrollbackOnly") }, -- 重置滚动位置
	-- ===== 字体大小 =====
	{ mods = "CTRL"      , key = "0", action = act.ResetFontSize    }, -- 重置字体大小
	{ mods = "CTRL"      , key = "-", action = act.DecreaseFontSize }, -- 减小字体
	{ mods = "CTRL|SHIFT", key = "+", action = act.IncreaseFontSize }, -- 增大字体
	-- ===== Tabs(标签页) =====
	{ mods = "CTRL|SHIFT", key = "t"  , action = act.SpawnTab("CurrentPaneDomain") }, -- 新建 tab
	{ mods = "CTRL"      , key = "Tab", action = act.ActivateTabRelative(1) }, -- 切换到下一个 tab
	{ mods = "CTRL|SHIFT", key = "Tab", action = act.ActivateTabRelative(-1)}, -- 切换到上一个 tab
	{ mods = "CTRL|SHIFT|ALT", key = "t", action = -- 修改当前 tab 标题
		act.PromptInputLine({
			description = "Enter a new title for the current tab",
			action = wezterm.action_callback(function(window, _, line)
				if line then window:active_tab():set_title(line) end
			end),
		}),
	},
	{ mods = 'CTRL|ALT', key = '1', action = act.ActivateTab(0) }, -- 切换标签页(按顺序1~9)
	{ mods = 'CTRL|ALT', key = '2', action = act.ActivateTab(1) },
	{ mods = 'CTRL|ALT', key = '3', action = act.ActivateTab(2) },
	{ mods = 'CTRL|ALT', key = '4', action = act.ActivateTab(3) },
	{ mods = 'CTRL|ALT', key = '5', action = act.ActivateTab(4) },
	{ mods = 'CTRL|ALT', key = '6', action = act.ActivateTab(5) },
	{ mods = 'CTRL|ALT', key = '7', action = act.ActivateTab(6) },
	{ mods = 'CTRL|ALT', key = '8', action = act.ActivateTab(7) },
	{ mods = 'CTRL|ALT', key = '9', action = act.ActivateTab(8) },
	-- ===== Pane(分屏) =====
	{ mods = "CTRL|SHIFT|ALT", key = "Enter", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) }, -- 水平分屏（左右）
	{ mods = "CTRL|SHIFT"    , key = "Enter", action = act.SplitVertical({ domain = "CurrentPaneDomain" })   }, -- 垂直分屏（上下）
	{ mods = "CTRL|SHIFT", key = "z", action = act.TogglePaneZoomState }, -- 当前 pane 最大化/还原
	{ mods = "CTRL|SHIFT", key = "w", action = act.CloseCurrentPane({ confirm = true }) }, -- 关闭当前 pane
	{ mods = "CTRL|SHIFT", key = "j", action = act.ActivatePaneDirection("Down")  }, -- 切换到下方 pane
	{ mods = "CTRL|SHIFT", key = "k", action = act.ActivatePaneDirection("Up")    }, -- 切换到上方 pane
	{ mods = "CTRL|SHIFT", key = "h", action = act.ActivatePaneDirection("Left")  }, -- 切换到左侧 pane
	{ mods = "CTRL|SHIFT", key = "l", action = act.ActivatePaneDirection("Right") }, -- 切换到右侧 pane
	{ mods = "CTRL|SHIFT", key = "LeftArrow" , action = act.AdjustPaneSize({ "Left" , 1 }) }, -- 向左调整 pane 大小
	{ mods = "CTRL|SHIFT", key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) }, -- 向右调整 pane 大小
	{ mods = "CTRL|SHIFT", key = "UpArrow"   , action = act.AdjustPaneSize({ "Up"   , 1 }) }, -- 向上调整 pane 大小
	{ mods = "CTRL|SHIFT", key = "DownArrow" , action = act.AdjustPaneSize({ "Down" , 1 }) }, -- 向下调整 pane 大小
	{ mods = "CTRL|SHIFT", key = "{", action = act({ ActivatePaneDirection = "Prev" }) }, -- 切换到上一个 pane
	{ mods = "CTRL|SHIFT", key = "}", action = act({ ActivatePaneDirection = "Next" }) }, -- 切换到下一个 pane
	{ mods = "CTRL|SHIFT", key = "r", action = act.PaneSelect({ mode = "SwapWithActiveKeepFocus" }) }, -- 选择 pane 并交换位置
	{ mods = "CTRL|SHIFT", key = "b", action = act.RotatePanes("CounterClockwise") }, -- pane 逆时针轮换
	{ mods = "CTRL|SHIFT", key = "n", action = act.RotatePanes("Clockwise") }, -- pane 顺时针轮换
}
return config
