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
  # Lua 配置: 以词定字
  select_first_character: "comma"  # ,
  select_last_character: "period"  # .

  bindings:
    # 翻页 [ ]
    - { when: paging, accept: bracketleft, send: Page_Up }
    - { when: has_menu, accept: bracketright, send: Page_Down }
    # Tab / Shift+Tab 切换光标至下/上一个拼音
    - { when: composing, accept: Shift+Tab, send: Shift+Left }
    - { when: composing, accept: Tab, send: Shift+Right }
 
    # numbered_mode_switch:
    # - { when: always, select: .next, accept: Control+Shift+1 }                  # 在最近的两个方案之间切换
    # - { when: always, select: .next, accept: Control+Shift+exclam }             # 在最近的两个方案之间切换
    # - { when: always, toggle: ascii_mode, accept: Control+Shift+2 }             # 切换中英
    # - { when: always, toggle: ascii_mode, accept: Control+Shift+at }            # 切换中英
    - { when: always, toggle: ascii_punct, accept: Control+Shift+3 }              # 切换中英标点
    - { when: always, toggle: ascii_punct, accept: Control+Shift+numbersign }     # 切换中英标点
    - { when: always, toggle: traditionalization, accept: Control+Shift+4 }       # 切换简繁
    - { when: always, toggle: traditionalization, accept: Control+Shift+dollar }  # 切换简繁
    # - { when: always, toggle: full_shape, accept: Control+Shift+5 }             # 切换全半角
    # - { when: always, toggle: full_shape, accept: Control+Shift+percent }       # 切换全半角
# 注释掉emacs_editing相关的快捷键
```

weasel.yml
```yml
# 针对应用配置
app_options:
  firefox.exe:
    inline_preedit: true
  msedge.exe:
    ascii_mode: true
  code.exe:
    ascii_mode: true
    vim_mode: true
  idea64.exe:
    ascii_mode: true
    vim_mode: true
  pycharm64.exe:
    ascii_mode: true
    vim_mode: true
  webstorm64.exe:
    ascii_mode: true
    vim_mode: true
  nvim.exe:
    ascii_mode: true
    vim_mode: true
  wezterm-gui.exe:
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

scheme.yml
```yml
switches:
  - name: ascii_mode
    reset: 1 # 默认用英文
  - name: ascii_punct
    reset: 1 # 默认用英文标点
```