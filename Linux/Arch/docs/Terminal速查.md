# WezTerm

> 自定义配置，通过 `wezterm show-keys` 查看

## 普通模式

### 命令与搜索
| 快捷键         | 功能     |
| -------------- | -------- |
| `ctrl+shift+p` | 命令面板 |
| `ctrl+shift+f` | 搜索     |

### 剪贴板
| 快捷键             | 功能               |
| ------------------ | ------------------ |
| `ctrl+shift+c`     | 复制到系统剪贴板   |
| `ctrl+shift+v`     | 从系统剪贴板粘贴   |
| `ctrl+shift+space` | 快速选择（URL 等） |
| `ctrl+shift+x`     | 进入复制模式       |

### 滚动
| 快捷键                 | 功能              |
| ---------------------- | ----------------- |
| `ctrl+shift+y`         | 向上滚动 3 行     |
| `ctrl+shift+e`         | 向下滚动 3 行     |
| `ctrl+shift+u`         | 跳到上一个 prompt |
| `ctrl+shift+d`         | 跳到下一个 prompt |
| `ctrl+shift+page_up`   | 向上翻页          |
| `ctrl+shift+page_down` | 向下翻页          |
| `ctrl+shift+home`      | 跳到顶部          |
| `ctrl+shift+end`       | 跳到底部          |
| `ctrl+shift+alt+home`  | 清空滚动缓冲区    |

### 字体大小
| 快捷键         | 功能         |
| -------------- | ------------ |
| `ctrl+shift++` | 增大字体     |
| `ctrl+-`       | 减小字体     |
| `ctrl+0`       | 重置字体大小 |

### 标签页
| 快捷键             | 功能                  |
| ------------------ | --------------------- |
| `ctrl+shift+t`     | 新建标签页            |
| `ctrl+tab`         | 下一个标签页          |
| `ctrl+shift+tab`   | 上一个标签页          |
| `ctrl+alt+t`       | 修改当前标签页标题    |
| `ctrl+alt+w`       | 关闭当前标签页        |
| `ctrl+alt+1` ~ `9` | 切换到第 1~9 个标签页 |

### 分屏
| 快捷键                 | 功能               |
| ---------------------- | ------------------ |
| `ctrl+shift+enter`     | 垂直分屏（上下）   |
| `ctrl+shift+alt+enter` | 水平分屏（左右）   |
| `ctrl+shift+h`         | 聚焦左侧分屏       |
| `ctrl+shift+j`         | 聚焦下方分屏       |
| `ctrl+shift+k`         | 聚焦上方分屏       |
| `ctrl+shift+l`         | 聚焦右侧分屏       |
| `ctrl+shift+{`         | 聚焦上一个分屏     |
| `ctrl+shift+}`         | 聚焦下一个分屏     |
| `ctrl+shift+left`      | 向左调整分屏大小   |
| `ctrl+shift+right`     | 向右调整分屏大小   |
| `ctrl+shift+up`        | 向上调整分屏大小   |
| `ctrl+shift+down`      | 向下调整分屏大小   |
| `ctrl+shift+z`         | 分屏最大化/还原    |
| `ctrl+shift+<`         | 逆时针轮换分屏     |
| `ctrl+shift+>`         | 顺时针轮换分屏     |
| `ctrl+shift+r`         | 选择分屏并交换位置 |
| `ctrl+shift+w`         | 关闭当前分屏       |

### 窗口
| 快捷键           | 功能     |
| ---------------- | -------- |
| `ctrl+shift+f11` | 切换全屏 |

---

## 鼠标操作

### 选择文本
| 操作                 | 功能               |
| -------------------- | ------------------ |
| `左键单击`           | 选择单元格         |
| `shift+左键单击`     | 扩展选择（单元格） |
| `alt+左键单击`       | 选择块             |
| `shift+alt+左键单击` | 扩展选择（块）     |
| `左键双击`           | 选择单词           |
| `左键三击`           | 选择行             |
| `左键拖动`           | 选择文本（单元格） |
| `alt+左键拖动`       | 选择文本（块）     |
| `双击拖动`           | 选择文本（单词）   |
| `三击拖动`           | 选择文本（行）     |

### 粘贴与链接
| 操作                 | 功能                         |
| -------------------- | ---------------------------- |
| `中键单击`           | 从主选区粘贴                 |
| `ctrl+左键松开`      | 打开链接                     |
| `shift+左键松开`     | 完成选择或打开链接           |
| `alt+左键松开`       | 完成选择（剪贴板+主选区）    |
| `shift+alt+左键松开` | 完成选择或打开链接（主选区） |
| `左键松开`           | 完成选择（主选区）           |
| `双击松开`           | 完成选择（主选区）           |
| `三击松开`           | 完成选择（主选区）           |

### 滚动
| 操作       | 功能          |
| ---------- | ------------- |
| `滚轮上滚` | 向上滚动 5 行 |
| `滚轮下滚` | 向下滚动 5 行 |

### 窗口拖动
| 操作                  | 功能     |
| --------------------- | -------- |
| `shift+ctrl+左键拖动` | 拖动窗口 |

---

## 复制模式（Copy Mode）

> 按 `ctrl+shift+x` 进入

### 移动
| 快捷键        | 功能           |
| ------------- | -------------- |
| `h` / `left`  | 左移           |
| `j` / `down`  | 下移           |
| `k` / `up`    | 上移           |
| `l` / `right` | 右移           |
| `w`           | 下一个单词     |
| `b` / `alt+b` | 上一个单词     |
| `e`           | 单词末尾       |
| `0`           | 行首           |
| `^`           | 行内容开始     |
| `$`           | 行尾           |
| `G`           | 滚动缓冲区底部 |
| `g`           | 滚动缓冲区顶部 |
| `H`           | 视口顶部       |
| `M`           | 视口中部       |
| `L`           | 视口底部       |
| `enter`       | 移动到下一行首 |
| `alt+m`       | 行内容开始     |
| `alt+left`    | 上一个单词     |
| `alt+right`   | 下一个单词     |

### 选择
| 快捷键        | 功能                    |
| ------------- | ----------------------- |
| `space` / `v` | 开始/停止选择（单元格） |
| `V`           | 开始/停止选择（行）     |
| `ctrl+v`      | 开始/停止选择（块）     |

### 跳转
| 快捷键 | 功能             |
| ------ | ---------------- |
| `f`    | 向前跳转到字符   |
| `F`    | 向后跳转到字符   |
| `t`    | 向前跳转到字符前 |
| `T`    | 向后跳转到字符后 |
| `;`    | 重复上次跳转     |
| `,`    | 反向重复上次跳转 |

### 翻页
| 快捷键                 | 功能       |
| ---------------------- | ---------- |
| `page_up` / `ctrl+b`   | 向上翻页   |
| `page_down` / `ctrl+f` | 向下翻页   |
| `ctrl+u`               | 向上翻半页 |
| `ctrl+d`               | 向下翻半页 |

### 选择端点
| 快捷键 | 功能                   |
| ------ | ---------------------- |
| `o`    | 跳到选择另一端         |
| `O`    | 跳到选择另一端（水平） |

### 复制与退出
| 快捷键              | 功能               |
| ------------------- | ------------------ |
| `y`                 | 复制到剪贴板并退出 |
| `q` / `escape`      | 退出复制模式       |
| `ctrl+c` / `ctrl+g` | 退出复制模式       |

---

## 搜索模式（Search Mode）

> 搜索时自动进入

| 快捷键      | 功能         |
| ----------- | ------------ |
| `enter`     | 上一个匹配   |
| `ctrl+n`    | 下一个匹配   |
| `ctrl+p`    | 上一个匹配   |
| `ctrl+r`    | 切换匹配类型 |
| `ctrl+u`    | 清除搜索模式 |
| `page_up`   | 上一页匹配   |
| `page_down` | 下一页匹配   |
| `up`        | 上一个匹配   |
| `down`      | 下一个匹配   |
| `escape`    | 关闭搜索     |

---

# Ghostty

> 自定义配置，通过 `ghostty +list-keybinds` 查看 (加 `--default` 为默认配置)

## 配置与命令
| 快捷键         | 功能     |
| -------------- | -------- |
| `ctrl+shift+,` | 重载配置 |
| `ctrl+shift+p` | 命令面板 |

## 搜索
| 快捷键         | 功能     |
| -------------- | -------- |
| `ctrl+shift+f` | 开始搜索 |
| `escape`       | 结束搜索 |

## 选择
| 快捷键         | 功能         |
| -------------- | ------------ |
| `ctrl+shift+a` | 全选         |
| `shift+left`   | 向左扩展选择 |
| `shift+right`  | 向右扩展选择 |
| `shift+up`     | 向上扩展选择 |
| `shift+down`   | 向下扩展选择 |

> 注：按住 `Ctrl+Alt` 鼠标可矩形选中

## 复制粘贴
| 快捷键                          | 功能               |
| ------------------------------- | ------------------ |
| `ctrl+shift+c` / `ctrl+insert`  | 复制               |
| `ctrl+shift+v` / `shift+insert` | 粘贴               |
| `copy`                          | 复制（专用复制键） |
| `paste`                         | 粘贴（专用粘贴键） |

## 滚动
| 快捷键                 | 功能              |
| ---------------------- | ----------------- |
| `ctrl+shift+y`         | 向上滚动 3 行     |
| `ctrl+shift+e`         | 向下滚动 3 行     |
| `ctrl+shift+u`         | 跳到上一个 prompt |
| `ctrl+shift+d`         | 跳到下一个 prompt |
| `ctrl+shift+page_up`   | 向上翻页          |
| `ctrl+shift+page_down` | 向下翻页          |
| `ctrl+shift+home`      | 跳到顶部          |
| `ctrl+shift+end`       | 跳到底部          |
| `ctrl+alt+shift+home`  | 清空滚动缓冲区    |

## 字体大小
| 快捷键         | 功能         |
| -------------- | ------------ |
| `ctrl+shift++` | 增大字体     |
| `ctrl+-`       | 减小字体     |
| `ctrl+0`       | 重置字体大小 |

## 标签页
| 快捷键             | 功能                  |
| ------------------ | --------------------- |
| `ctrl+shift+t`     | 新建标签页            |
| `ctrl+tab`         | 下一个标签页          |
| `ctrl+shift+tab`   | 上一个标签页          |
| `ctrl+alt+shift+t` | 修改当前标签页标题    |
| `ctrl+alt+shift+w` | 关闭当前标签页        |
| `ctrl+alt+1` ~ `9` | 切换到第 1~9 个标签页 |

## 分屏
| 快捷键                 | 功能             |
| ---------------------- | ---------------- |
| `ctrl+shift+enter`     | 水平分屏（右）   |
| `ctrl+alt+shift+enter` | 垂直分屏（下）   |
| `ctrl+shift+h`         | 聚焦左侧分屏     |
| `ctrl+shift+j`         | 聚焦下方分屏     |
| `ctrl+shift+k`         | 聚焦上方分屏     |
| `ctrl+shift+l`         | 聚焦右侧分屏     |
| `ctrl+shift+[`         | 聚焦上一个分屏   |
| `ctrl+shift+]`         | 聚焦下一个分屏   |
| `ctrl+shift+left`      | 向左调整分屏大小 |
| `ctrl+shift+right`     | 向右调整分屏大小 |
| `ctrl+shift+up`        | 向上调整分屏大小 |
| `ctrl+shift+down`      | 向下调整分屏大小 |
| `ctrl+shift+z`         | 分屏最大化/还原  |
| `ctrl+shift+\|`        | 均衡所有分屏大小 |
| `ctrl+shift+w`         | 关闭当前分屏     |

## 窗口
| 快捷键           | 功能     |
| ---------------- | -------- |
| `ctrl+shift+f11` | 切换全屏 |
| `alt+f4`         | 关闭窗口 |

---

# Kitty

> 默认键位，使用 `kitty_mod`（默认为 `ctrl+shift`）

## 剪贴板
| 快捷键                          | 功能             |
| ------------------------------- | ---------------- |
| `ctrl+shift+c`                  | 复制到剪贴板     |
| `ctrl+shift+v`                  | 从剪贴板粘贴     |
| `ctrl+shift+s` / `shift+insert` | 从选区粘贴       |
| `ctrl+shift+o`                  | 将选区传递给程序 |

## 滚动
| 快捷键                             | 功能                      |
| ---------------------------------- | ------------------------- |
| `ctrl+shift+up` / `ctrl+shift+k`   | 向上滚动一行              |
| `ctrl+shift+down` / `ctrl+shift+j` | 向下滚动一行              |
| `ctrl+shift+page_up`               | 向上滚动一页              |
| `ctrl+shift+page_down`             | 向下滚动一页              |
| `ctrl+shift+home`                  | 滚动到顶部                |
| `ctrl+shift+end`                   | 滚动到底部                |
| `ctrl+shift+z`                     | 滚动到上一个 shell 提示符 |
| `ctrl+shift+x`                     | 滚动到下一个 shell 提示符 |
| `ctrl+shift+h`                     | 在分页器中浏览滚动缓冲区  |
| `ctrl+shift+g`                     | 浏览最后一个命令输出      |
| `ctrl+shift+/`                     | 在分页器中搜索            |

## 窗口管理
| 快捷键                                         | 功能                 |
| ---------------------------------------------- | -------------------- |
| `ctrl+shift+enter`                             | 新建窗口             |
| `ctrl+shift+n`                                 | 新建 OS 窗口         |
| `ctrl+shift+w`                                 | 关闭窗口             |
| `ctrl+shift+]`                                 | 下一个窗口           |
| `ctrl+shift+[`                                 | 上一个窗口           |
| `ctrl+shift+f`                                 | 向前移动窗口         |
| `ctrl+shift+b`                                 | 向后移动窗口         |
| <code>ctrl+shift+`</code>     | 移动窗口到顶部 |                      |
| `ctrl+shift+r`                                 | 开始调整窗口大小     |
| `ctrl+shift+1` ~ `0`                           | 聚焦第 1~10 个窗口   |
| `ctrl+shift+f7`                                | 可视化选择并聚焦窗口 |
| `ctrl+shift+f8`                                | 可视化交换窗口       |

## 标签页
| 快捷键                               | 功能             |
| ------------------------------------ | ---------------- |
| `ctrl+shift+right` / `ctrl+tab`      | 下一个标签页     |
| `ctrl+shift+left` / `ctrl+shift+tab` | 上一个标签页     |
| `ctrl+shift+t`                       | 新建标签页       |
| `ctrl+shift+q`                       | 关闭标签页       |
| `ctrl+shift+.`                       | 向前移动标签页   |
| `ctrl+shift+,`                       | 向后移动标签页   |
| `ctrl+shift+alt+t`                   | 设置标签页标题   |
| `ctrl+alt+1` ~ `9`                   | 跳转到特定标签页 |

## 布局
| 快捷键         | 功能             |
| -------------- | ---------------- |
| `ctrl+shift+l` | 下一个布局       |
| `ctrl+alt+t`   | 跳转到高布局     |
| `ctrl+alt+s`   | 跳转到堆叠布局   |
| `ctrl+alt+p`   | 上次使用的布局   |
| `ctrl+alt+z`   | 切换布局（缩放） |

## 字体大小
| 快捷键                                 | 功能         |
| -------------------------------------- | ------------ |
| `ctrl+shift+equal` / `ctrl+shift+plus` | 增大字体     |
| `ctrl+shift+minus`                     | 减小字体     |
| `ctrl+shift+backspace`                 | 重置字体大小 |

## 选择并操作可见文本
| 快捷键                 | 功能                 |
| ---------------------- | -------------------- |
| `ctrl+shift+e`         | 打开 URL             |
| `ctrl+shift+p>f`       | 插入选定路径         |
| `ctrl+shift+p>shift+f` | 打开选定路径         |
| `ctrl+shift+p>c`       | 插入选择的文件       |
| `ctrl+shift+p>d`       | 插入选择的目录       |
| `ctrl+shift+p>l`       | 插入选定行           |
| `ctrl+shift+p>w`       | 插入选定单词         |
| `ctrl+shift+p>h`       | 插入选定哈希         |
| `ctrl+shift+p>n`       | 在选定行打开选定文件 |
| `ctrl+shift+p>y`       | 打开选定的超链接     |

## 其他
| 快捷键              | 功能                  |
| ------------------- | --------------------- |
| `ctrl+shift+f1`     | 显示文档              |
| `ctrl+shift+f3`     | 命令面板              |
| `ctrl+shift+f11`    | 切换全屏              |
| `ctrl+shift+f10`    | 切换最大化            |
| `ctrl+shift+u`      | Unicode 输入          |
| `ctrl+shift+f2`     | 编辑配置文件          |
| `ctrl+shift+escape` | 打开 kitty 命令 shell |
| `ctrl+shift+a>m`    | 增加背景不透明度      |
| `ctrl+shift+a>l`    | 减少背景不透明度      |
| `ctrl+shift+a>1`    | 背景完全不透明        |
| `ctrl+shift+a>d`    | 重置背景不透明度      |
| `ctrl+shift+delete` | 重置终端              |
| `ctrl+shift+f5`     | 重新加载 kitty.conf   |
| `ctrl+shift+f6`     | 调试 kitty 配置       |
