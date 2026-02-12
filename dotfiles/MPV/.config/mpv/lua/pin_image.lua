-- MPV桌面贴图功能脚本
-- 调用方式: mpv img_path --script="lua_path" --no-config --no-input-builtin-bindings

-------------------------------------------------------------
-- 窗口与界面行为初始化 (对应命令行参数)
-------------------------------------------------------------
-- 注意：no-config 和 no-input-builtin-bindings 必须在命令行开启，无法在脚本内追溯
-- 窗口行为
mp.set_property("ontop", "yes")                  -- --ontop: 置顶显示
mp.set_property("border", "no")                  -- --border=no: 无边框
mp.set_property("window-dragging", "yes")        -- --window-dragging: 允许点击窗口任意位置拖动
mp.set_property("auto-window-resize", "no")      -- --no-auto-window-resize: 禁用自动调整窗体大小
-- 界面精简
mp.set_property("title-bar", "no")               -- --title-bar=no: 隐藏标题栏
mp.set_property("osc", "no")                     -- --osc=no: 关闭底部进度条控制浮层
-- 看图行为
mp.set_property("image-display-duration", "inf") -- --image-display-duration=inf: 图片永不退出
mp.set_property("loop-playlist", "inf")          -- --loop-playlist=inf: 无限循环播放(用于gif循环)
mp.set_property("autoload-files", "no")          -- --autoload-files=no: 禁止加载同目录其他文件
-- 性能优化
mp.set_property("audio", "no")                   -- --no-audio: 禁用音频
mp.set_property("vd", "null")                    -- --vd=no (在API中通常设为null): 禁用视频解码器
mp.set_property("hwdec", "no")                   -- --hwdec=no: 关闭硬件解码器

-------------------------------------------------------------
-- 功能快捷键
-- c 复制 ; s 保存 ; a/d 旋转 ; e编辑 ; 滚轮缩放 ; 双击退出
-- 编辑功能调用 spectacle
-------------------------------------------------------------
local function copy_to_clipboard()
    local path = mp.get_property('path')
    if not path then return end
    mp.commandv('run', 'sh', '-c', 'wl-copy < "' .. path .. '"')
    mp.osd_message('已复制到剪贴板', 1)
end
local function save_to_file()
    local path = mp.get_property('path')
    if not path then return end
    local save_dir = os.getenv('HOME') .. '/Desktop'
    local timestamp = os.date('%Y%m%d_%H%M%S')
    local dest = save_dir .. '/ss_' .. timestamp .. '.png'
    mp.commandv('run', 'cp', path, dest)
    mp.osd_message('已保存: ' .. dest, 2)
end
local function zoom_in()
    local scale = mp.get_property_number('window-scale') or 1
    if scale < 5 then
        mp.set_property('window-scale', scale + 0.1)
        mp.osd_message('放大: ' .. string.format('%.1fx', scale + 0.1), 0.5)
    end
end
local function zoom_out()
    local scale = mp.get_property_number('window-scale') or 1
    if scale > 0.2 then
        mp.set_property('window-scale', scale - 0.1)
        mp.osd_message('缩放: ' .. string.format('%.1fx', scale - 0.1), 0.5)
    end
end
local function rotate_cw()
    local angle = mp.get_property_number('video-rotate') or 0
    local new_angle = (angle + 90) % 360
    mp.set_property('video-rotate', new_angle)
    mp.osd_message('旋转: ' .. new_angle .. '°', 0.5)
end
local function rotate_ccw()
    local angle = mp.get_property_number('video-rotate') or 0
    local new_angle = (angle - 90) % 360
    if new_angle < 0 then new_angle = new_angle + 360 end
    mp.set_property('video-rotate', new_angle)
    mp.osd_message('旋转: ' .. new_angle .. '°', 0.5)
end
local function edit_image()
    local path = mp.get_property('path')
    if not path or path == "" then return end
    mp.commandv('run', 'spectacle', '-E', path)
    -- mp.command('quit') -- 编辑后关闭mpv显示
    mp.osd_message('已送往 Spectacle 编辑器', 1)
end

mp.add_key_binding('c', 'copy-to-clipboard', copy_to_clipboard)
mp.add_key_binding('s', 'save-to-file', save_to_file)
mp.add_key_binding('a', 'rotate-ccw', rotate_ccw)
mp.add_key_binding('d', 'rotate-cw', rotate_cw)
mp.add_key_binding('e', 'edit-image', edit_image)
mp.add_key_binding('WHEEL_UP', 'zoom-in', zoom_in)
mp.add_key_binding('WHEEL_DOWN', 'zoom-out', zoom_out)
mp.add_key_binding('MOUSE_BTN0_DBL', 'dbl_click_quit', function() mp.command('quit') end)

-------------------------------------------------------------
-- 像素边框
-------------------------------------------------------------
local border_overlay = mp.create_osd_overlay("ass-events")
local function update_border()
    local ww = mp.get_property_number("osd-width")
    local wh = mp.get_property_number("osd-height")
    if not ww or not wh then return end
    border_overlay.res_x = ww
    border_overlay.res_y = wh
    -- ASS 描边以路径为中心渲染(\bord1 = ±0.5px)
    -- 因此将路径放在 0.5 / w-0.5 处, 使整条 1px 描边完全落在窗口内部并紧贴边缘
    local x0, y0 = 0.5, 0.5
    local x1, y1 = ww - 0.5, wh - 0.5
    local ass_data = string.format(
        "{\\an7\\pos(0,0)\\bord1\\shad0\\3c&H777777&\\1a&HFF&\\p1}m %f %f l %f %f %f %f %f %f{\\p0}",
        x0, y0,  -- 起点
        x1, y0,  -- 右上
        x1, y1,  -- 右下
        x0, y1   -- 左下
    )
    border_overlay.data = ass_data
    border_overlay:update()
end
-- 边框: 加载后立即刷新
mp.register_event("file-loaded", function() mp.add_timeout(0.05, update_border) end)
-- 边框: 监听窗口变化
mp.observe_property("osd-width", "number", update_border)
mp.observe_property("osd-height", "number", update_border)