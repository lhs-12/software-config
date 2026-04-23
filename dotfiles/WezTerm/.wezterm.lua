local wezterm = require("wezterm")
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end
local act = wezterm.action
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
	config.front_end = "WebGpu"
	-- Fix Linux window
	config.window_decorations = "NONE"
	config.hide_tab_bar_if_only_one_tab = true
	config.tab_bar_at_bottom = true
	config.use_fancy_tab_bar = false
end
-- Microsoft Windows Config
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	-- local msys2_bash = { "cmd.exe", "/k", "C:\\msys64\\msys2_shell.cmd -defterm -here -no-start -ucrt64 -shell bash", "-l", "-i" }
	local msys2_bash = { "C:\\msys64\\msys2_shell.cmd", "-defterm", "-here", "-no-start", "-ucrt64", "-shell", "bash" }
	local msys2_fish = { "C:\\msys64\\msys2_shell.cmd", "-defterm", "-here", "-no-start", "-ucrt64", "-shell", "fish" }
	config.default_prog = msys2_fish
	config.launch_menu = {
		{ label = "Bash", args = msys2_bash },
		{ label = "Fish", args = msys2_fish },
		{ label = "CMD", args = { "cmd.exe" } },
		{ label = "PowerShell5", args = { "powershell.exe" } },
		{ label = "PowerShell7", args = { "pwsh.exe"       } },
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
		window:gui_window():set_position(520, 250)
	end)
end
-- Mouse
-- stylua: ignore
config.mouse_bindings = {
	-- 鼠标滚动行数
	{ event = { Down = { streak = 1, button = { WheelUp = 1 } } }, mods = "NONE", action = wezterm.action.ScrollByLine(-5), alt_screen = false },
	{ event = { Down = { streak = 1, button = { WheelDown = 1 } } }, mods = "NONE", action = wezterm.action.ScrollByLine(5), alt_screen = false },
	-- ctrl + 左键单击 -> 打开链接
	{ event = { Up = { streak = 1, button = 'Left' } }, mods = 'CTRL', action = act.OpenLinkAtMouseCursor },
	-- 无修饰键 + 左键单击 -> 仅复制到主选区, 不复制到剪贴板
	{ event = { Up = { streak = 1, button = "Left" } }, mods = "NONE", action = act.CompleteSelection("PrimarySelection") },
	{ event = { Up = { streak = 2, button = "Left" } }, mods = "NONE", action = act.CompleteSelection("PrimarySelection") },
	{ event = { Up = { streak = 3, button = "Left" } }, mods = "NONE", action = act.CompleteSelection("PrimarySelection") },
}
-- Keys
-- 可使用 wezterm show-keys --lua 检查完整快捷键配置
config.disable_default_key_bindings = true
config.use_dead_keys = false
-- stylua: ignore
config.keys = {
	-- ===== 命令面板 =====
	{ mods = "CTRL|SHIFT", key = "p", action = act.ActivateCommandPalette }, -- 打开命令面板
	-- ===== 搜索 =====
	{ mods = "CTRL|SHIFT", key = "f", action = act.Search({ CaseSensitiveString = "" }) }, -- 搜索终端历史
	-- ===== 选择 / 复制 =====
	{ mods = "CTRL|SHIFT", key = "c"    , action = act.CopyTo("Clipboard")    }, -- 复制
	{ mods = "CTRL|SHIFT", key = "v"    , action = act.PasteFrom("Clipboard") }, -- 粘贴
	{ mods = "CTRL|SHIFT", key = "Space", action = act.QuickSelect            }, -- 快速复制 URL / 文件名等文本
	{ mods = "CTRL|SHIFT", key = "x"    , action = act.ActivateCopyMode       }, -- 进入复制模式
	-- ===== 滚动 =====
	{ mods = "CTRL|SHIFT", key = "y", action = act.ScrollByLine(-3) }, -- 向上滚动行
	{ mods = "CTRL|SHIFT", key = "e", action = act.ScrollByLine(3)  }, -- 向下滚动行
	{ mods = "CTRL|SHIFT", key = "u", action = act.ScrollToPrompt(-1) }, -- 跳到上一个prompt
	{ mods = "CTRL|SHIFT", key = "d", action = act.ScrollToPrompt(1)  }, -- 跳到下一个prompt
	{ mods = "CTRL|SHIFT", key = "PageUp", action = act.ScrollByPage(-1)  }, -- 向上滚动一页
	{ mods = "CTRL|SHIFT", key = "PageDown", action = act.ScrollByPage(1) }, -- 向下滚动一页
	{ mods = "CTRL|SHIFT", key = "Home", action = act.ScrollToTop }, -- 跳到顶部
	{ mods = "CTRL|SHIFT", key = "End", action = act.ScrollToBottom }, -- 跳到底部
	{ mods = "CTRL|SHIFT|ALT", key = "Home", action = act.ClearScrollback("ScrollbackOnly") }, -- 清空scrollback
	-- ===== 窗口管理 =====
	{ mods = 'CTRL|SHIFT', key = 'F11', action = act.ToggleFullScreen }, -- 最大化
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
	{ mods = "CTRL|SHIFT|ALT", key = "w", action = act.CloseCurrentTab({ confirm = false }) }, -- 关闭当前 tab
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
	{ mods = "CTRL|SHIFT", key = "w", action = act.CloseCurrentPane({ confirm = false }) }, -- 关闭当前 pane
	{ mods = "CTRL|SHIFT|ALT", key = "Enter", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) }, -- 水平分屏
	{ mods = "CTRL|SHIFT"    , key = "Enter", action = act.SplitVertical({ domain = "CurrentPaneDomain" })   }, -- 垂直分屏
	{ mods = "CTRL|SHIFT", key = "h", action = act.ActivatePaneDirection("Left") }, -- 导航到左侧 pane
	{ mods = "CTRL|SHIFT", key = "j", action = act.ActivatePaneDirection("Down") }, -- 导航到下方 pane
	{ mods = "CTRL|SHIFT", key = "k", action = act.ActivatePaneDirection("Up")   }, -- 导航到上方 pane
	{ mods = "CTRL|SHIFT", key = "l", action = act.ActivatePaneDirection("Right")}, -- 导航到右侧 pane
	{ mods = "CTRL|SHIFT", key = "{", action = act.ActivatePaneDirection("Prev") }, -- 导航到上一个 pane
	{ mods = "CTRL|SHIFT", key = "}", action = act.ActivatePaneDirection("Next") }, -- 导航到下一个 pane
	{ mods = "CTRL|SHIFT", key = "<", action = act.RotatePanes("CounterClockwise") }, -- 切换 pane
	{ mods = "CTRL|SHIFT", key = ">", action = act.RotatePanes("Clockwise")        }, -- 切换 pane
	{ mods = "CTRL|SHIFT", key = "r", action = act.PaneSelect({ mode = "SwapWithActiveKeepFocus" }) }, -- 切换到选中 pane
	{ mods = "CTRL|SHIFT", key = "LeftArrow" , action = act.AdjustPaneSize({ "Left" , 1 }) }, -- 向左调整 pane 大小
	{ mods = "CTRL|SHIFT", key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) }, -- 向右调整 pane 大小
	{ mods = "CTRL|SHIFT", key = "UpArrow"   , action = act.AdjustPaneSize({ "Up"   , 1 }) }, -- 向上调整 pane 大小
	{ mods = "CTRL|SHIFT", key = "DownArrow" , action = act.AdjustPaneSize({ "Down" , 1 }) }, -- 向下调整 pane 大小
	{ mods = "CTRL|SHIFT", key = "z", action = act.TogglePaneZoomState }, -- 当前 pane 最大化/还原
	-- ===== 字体大小 =====
	{ mods = "CTRL"      , key = "0", action = act.ResetFontSize    }, -- 重置字体大小
	{ mods = "CTRL"      , key = "-", action = act.DecreaseFontSize }, -- 减小字体
	{ mods = "CTRL|SHIFT", key = "+", action = act.IncreaseFontSize }, -- 增大字体
}
return config
