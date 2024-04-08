# <center>RIME输入法</center>

# 下载安装

1. 下载[RIME输入法](https://github.com/rime/weasel)
2. 下载配置: [雾凇拼音](https://github.com/iDvel/rime-ice), 覆盖到用户文件夹目录

# 修改配置
default.yml
```yml
schema_list:
  # 删除不需要的方案配置以及对应的 *.schema.yaml 方案文件
  - schema: rime_ice               # 雾凇拼音（全拼）
  - schema: double_pinyin_flypy    # 小鹤双拼

menu:
  page_size: 9  # 候选词个数

# 方案选单相关
switcher:
  caption: 「方案选单」
  hotkeys:
    # 触发选单只保留 ctrl + ` 这个快捷键
    - Control+grave

# 中西文切换
ascii_composer:
  good_old_caps_lock: true
  switch_key:
    Caps_Lock: clear       # commit_code | commit_text | clear
    Shift_L: noop          # commit_code | commit_text | inline_ascii | clear | noop
    Shift_R: noop          # commit_code | commit_text | inline_ascii | clear | noop
    Control_L: commit_code # commit_code | commit_text | inline_ascii | clear | noop
    Control_R: noop        # commit_code | commit_text | inline_ascii | clear | noop

# 快捷键
key_binder:
  # Lua 配置: 以词定字, 注释掉, 不用
  # select_first_character: "bracketleft"  # 左中括号 [
  # select_last_character: "bracketright"  # 右中括号 ]
  # 用 [ ] 翻页
  - { when: paging, accept: bracketleft, send: Page_Up }
  - { when: has_menu, accept: bracketright, send: Page_Down }

# 注释掉emacs_editing相关的快捷键
```

weasel.yml
```yml
# VSCode和IDEA默认英文, 支持vim切换
# 注: 15.0版本的win版本的vim_mode暂不生效. 更新软件版本, 或自己写lua脚本实现
app_options:
  firefox.exe:
    inline_preedit: true # 行内显示预编辑区：规避 <https://github.com/rime/weasel/issues/946>
  code.exe:
    ascii_mode: true
    vim_mode: true
  idea64.exe:
    ascii_mode: true
    vim_mode: true
  nvim.exe:
    ascii_mode: true
    vim_mode: true
  windowsterminal.exe:
    ascii_mode: true
    vim_mode: true

style:
  color_scheme: steam       # 默认配色方案
  # 字体
  font_face: "Noto Sans Mono CJK SC, Segoe UI Emoji, Noto Color Emoji"
  label_font_face: "Noto Sans Mono CJK SC"       # 标签字体
  comment_font_face: "Noto Sans Mono CJK SC"     # 注释字体
  font_point: 12                           # 全局字体字号
  label_font_point: 12                     # 标签字体字号，不设定 fallback 到 font_point
  comment_font_point: 11                   # 注释字体字号，不设定 fallback 到 font_point

# 删掉过多的主题色配置preset_color_schemes
# 可保留: 安卓, 碧水, 青天, 轻盈, 谷歌, 墨池, 孤寺, 现代蓝, 远山, 幽能, 晒经石, Steam
```

# vim命令模式切换英文输入法(Win11临时兼容)
15.0的win版本暂时没上线vim切换功能, 先自己写lua脚本实现

lua目录添加文件: win_vim_mode.lua
```lua
local function is_win()
    local path_separator = package.config:sub(1, 1)
    if path_separator == '\\' then
        return true
    end
    return false
end

-- Vim模式输入法自动切换
local function win_vim_mode(key, env)
    -- 如果是Win
    if is_win() then
        -- 如果按下了Ctrl+[
        if key:repr() == "Control+bracketleft" then
            -- 检测当前是不是英文模式
            local get_ascii_mode = env.engine.context:get_option("ascii_mode")
            -- 如果不是英文模式, 就切换到英文模式
            if not get_ascii_mode then
                env.engine.context:set_option("ascii_mode", true)
            end
            -- 因为前面的输入被接管了, 所有需要重新发送一次给Vim, 使其到Normal模式
            env.engine.commit_text("Control+bracketleft")
            return 1
        end
        -- 如果按下了Esc
        if key:repr() == "Escape" then
            local get_ascii_mode = env.engine.context:get_option("ascii_mode")
            if not get_ascii_mode then
                env.engine.context:set_option("ascii_mode", true)
            end
            env.engine.commit_text("Escape")
            return 1
        end
    end
    return 2
end

return win_vim_mode
```

修改使用的拼音输入法的scheme文件, 比如`rime_ice.schema.yaml`, 添加lua脚本功能作为lua_processor
```yml
engine:
  processors:
    - lua_processor@*win_vim_mode      # win模式下的vim模式切换脚本
    # - lua_processor@select_character  # 以词定字, 不用
```