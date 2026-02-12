# <center>IDEA 配置</center>

基于 IDEA 2025.3

# 插件

```bash
# 对以下内容使用vi命令编辑
# Windows 用 PowerShell执行. 命令:g/^s*$\|^#.*/d | %s/\\.*/`/
# Linux 命令:g/^s*$\|^#.*/d | %s/\\.*/\\/
# 把 idea 换成二进制文件路径, 比如 ~/.local/share/JetBrains/Toolbox/apps/intellij-idea/bin/idea

idea installPlugins \
mobi.hsz.idea.gitignore \                                   # .ignore
com.jetbrains.plugins.ini4idea \                            # Ini
ru.adelf.idea.dotenv \                                      # .env files support
com.mallowigi \                                             # Atom Material Icons
TheBlind.privateNotes \                                     # Private Notes
com.bruce.intellijplugin.generatesetter \                   # GenerateAllSetter
GenerateSerialVersionUID \                                  # GenerateSerialVersionUID
com.intellij.reactivestreams \                              # Reactive Streams
com.ccnode.codegenerator.MyBatisCodeHelperProMarketPlace \  # MyBatisCodeHelperPro(Marketplace Edition)
MavenRunHelper \                                            # Maven Helper
cn.yiiguxing.plugin.translate \                             # Translation
com.alibaba.p3c.xenoamess \                                 # Alibaba Java Coding Guidelines
CheckStyle-IDEA \                                           # CheckStyle-IDEA
com.intellij.plugins.html.instantEditing \                  # Live Edit
Pythonid \                                                  # Python
PythonCore \                                                # Python Common
SequenceDiagram \                                           # SequenceDiagram Core
vanstudio.sequence.java \                                   # SequenceDiagram Java
IdeaVIM \                                                   # IdeaVim
eu.theblob42.idea.whichkey \                                # Which-Key
com.joshestein.ideavim-quickscope \                         # IdeaVim-Quickscope
org.jetbrains.IdeaVim-EasyMotion \                          # IdeaVim-EasyMotion
AceJump \                                                   # AceJump
com.julienphalip.ideavim.switch \                           # Vim Switch
com.julienphalip.ideavim.peekaboo \                         # Vim Peekaboo
com.julienphalip.ideavim.functiontextobj \                  # Vim FunctionTextObj

# linux 环境增加插件
com.github.l34130.mise \                                    # Mise
IdeaVimExtension \                                          # IdeaVimExtension (Vim输入法自动切换)

# 其他
# Big Data Tools 系列插件
# Spring系列相关插件, 搜 /vendor:"JetBrains s.r.o." Spring
# String Manipulation
```

# 快捷键

- Close Others Tabs 改为 Ctrl Shift F4
- Vim 开关 改为 Ctrl Alt k

# 设置

Settings 界面:

- Appearance & Behavior -> System Settings -> 取消 Reopen last project on startup
- Appearance & Behavior -> System Settings -> 配置 Default project directory
- Editor -> File Types -> Ignore files 中加入 `*.iml;.idea;.vscode;`
- Editor -> General -> 勾选 Change font size with Ctrl + Mouse Wheel
- Editor -> General -> Code Completion -> 取消 Match case
- Editor -> General -> Code Folding -> Java -> 取消勾选 One-line methods
- Editor -> General -> Auto Import -> Insert imports on paste 选 Always, 勾选 Add unambiguous....和 Optimize import....
- Editor -> File Encodings -> 全部改 UTF8, 视情况勾选 Transparent native-to-ascii conversion
- Editor -> Code Style -> Line separator 改为'Unix and macOS (\n)'
- Editor -> Code Style -> Hard Wrap at 的数量调 180
- Editor -> Code Style -> Java -> Wrapping and Braces -> Method call arguments/Chain method calls/for() -> statement: Chop down if long
- Editor -> Code Style -> Java -> Wrapping and Braces -> Group declarations -> 勾选 Align (fields 和 variables) in columns
- Version Control -> Git -> 检查 Git 配置
- Version Control -> Commit -> Commit Checks 勾选 Optimize imports
- Maven -> 检查 settings.xml 配置情况
- 选用: Editor -> Editor Tabs -> 取消 Show tabs in one row

菜单栏:

- File -> Projects Structure -> 配置项目 SDK
- File -> New Projects Setup -> Settings for New Projects -> File Encodings 全部改 UTF-8
- View -> Appearance -> 勾选 Compact Mode
- 项目的折叠: 点击 Project 那个位置的省略号, 取消勾选 "Compact Middle Packages"


# 代码模板

Editor -> File and Code Templates -> includes -> FileHeader

```
/**
 * @author L
 */
```

Live Templates 的 "Spring Java" 组添加 "test" 方法, 设置 Abbreviation: test, Applicable: Java -> declaration

```
@Test
public void test$NAME$() {
    $END$
}
```

# 主题配置

步骤:

- 安装插件 Material Theme UI Lite, 选择主题 Arc Dark 导出 icls 文件, 卸载插件
- 安装插件 Burnt Theme, 借用其底色#1D1D1D
- Editor -> Color Scheme -> 导入 Arc Dark 主题, 然后开始配置

配置:

- Appearance & Behavior -> File Colors -> Test 改颜色(282828), Non-Project Files 改为 Green
- Editor -> Font -> "Sarasa Term SC" 16 1.0
- Editor -> Color Scheme -> Color Scheme Font -> "Iosevka Term Medium" + "MiSans", size: 16, line height: 1
- Editor -> Color Scheme -> Console Font -> "Sarasa Term SC" + "Symbols Nerd Font Mono" 13 1
- Editor -> Color Scheme -> General -> Text -> Default text -> Background: 1D1D1D
- Editor -> Color Scheme -> General -> Editor -> Gutter background -> 取消 Background
- Editor -> Color Scheme -> General -> Editor -> Caret row -> Background: 323232
- Editor -> Color Scheme -> General -> Editor -> Selection background 182F4B , Selection foreground 取消
- Editor -> Color Scheme -> General -> Editor -> Popups and Hints -> Completion 取消 background
- Editor -> Color Scheme -> General -> Errors and Warnings -> Unused code -> Foreground: 556868
- Editor -> Color Scheme -> General -> Popups and Hints -> Documentation -> Background: 323232
- Editor -> Color Scheme -> Console Colors -> Console -> Background: 1D1D1D
- Editor -> Color Scheme -> Language Defaults -> Template language -> Background: 282828
- Editor -> Color Scheme -> General -> Search Results -> Text Search Result -> Background: FBE71C
- Editor -> Color Scheme -> General -> Code -> Identifer 开头的 -> 取消 foreground/background,Error strip mark(4D6168)
- Editor -> Color Scheme -> Java -> 三种注释和 Keyword 都取消斜体

# IdeaVim 配置

修改配置文件(.ideavimrc), RIME 输入法开启 Vim 模式

IDEA 以及 Vim 快捷键功能对照参考
| 快捷键         | IDEA 功能          | 插入模式                                     | 普通模式                            | 可视模式                                   | 命令行模式                                       |
| -------------- | ------------------ | -------------------------------------------- | ----------------------------------- | ------------------------------------------ | ------------------------------------------------ |
| Ctrl+2         | 去书签 2           | 通常等同于 Ctrl+@                            | 通常等同于 Ctrl+@                   | 无特定作用                                 | 无作用                                           |
| Ctrl+@         | 触发书签 2         | 插入上次插入的文本并停止插入                 | 无特定 Vim 功能                     | 无特定作用                                 | 无作用                                           |
| Ctrl+6         | 去书签 6           | 等同于 Ctrl+^                                | 等同于 Ctrl+^                       | 等同于 Ctrl+^                              | 无作用                                           |
| Ctrl+^         | 触发书签 6         | 无作用                                       | 编辑备用文件(:e #)或第 N 个备用文件 | 编辑备用文件(:e #)或第 N 个备用文件        | 无作用                                           |
| Ctrl+[         | 跳到附近大括号头部 | 同 Esc 键，回到普通模式                      | 同 Esc 键                           | 同 Esc 键，回到普通模式                    | 同 Esc 键, 取消命令行                            |
| Ctrl+]         | 跳到附近大括号尾部 | 无作用                                       | 跳转到光标下标识符的定义处          | 跳转到选中标识符的定义处                   | 无作用                                           |
| Ctrl+\         | 文件选择列表根目录 | 部分组合快捷键的前缀                         | 部分组合快捷键的前缀                | 部分组合快捷键的前缀                       | 无作用                                           |
| Ctrl+/         | 注释               | 等同于 Ctrl+_, 无用                          | 等同于 Ctrl+_, 无用                 | 等同于 Ctrl+_, 无用                        | 等同于 Ctrl+_, 无用                              |
| Ctrl+Delete    | 向后删除单词       | 无标准 Vim 功能                              | 无标准 Vim 功能                     | 无标准 Vim 功能                            | 无标准 Vim 功能                                  |
| Ctrl+Backspace | 向前删除单词       | 无标准 Vim 功能                              | 无标准 Vim 功能                     | 无标准 Vim 功能                            | 无标准 Vim 功能                                  |
| Ctrl+↑         | 向上滚动           | 光标向上移一行(特殊键)                       | 上移[count]行(同<C-Up>)             | 上移[count]行                              | 召回匹配光标前模式的较旧历史命令                 |
| Ctrl+↓         | 向下滚动           | 光标向下移一行(特殊键)                       | 下移[count]行(同<C-Down>)           | 下移[count]行                              | 召回匹配光标前模式的较新历史命令                 |
| Ctrl+←         | 向左跳转单词       | 光标左移一个单词(特殊键)                     | 左移一个单词(同 b)                  | 扩展选择左移一个单词                       | 光标左移一个单词                                 |
| Ctrl+→         | 向右跳转单词       | 光标右移一个单词(特殊键)                     | 右移一个单词(同 w)                  | 扩展选择右移一个单词                       | 光标右移一个单词                                 |
| Ctrl+a         | 全选               | 插入上次插入的文本                           | 光标下或后的数字/字母加[count]      | 高亮文本中的数字/字母加[count]             | 在光标前模式上补全并插入所有匹配                 |
| Ctrl+b         | 去声明或使用处     | 无作用                                       | 向上滚动[count]页                   | 向上滚动[count]页                          | 光标移到命令行开头                               |
| Ctrl+c         | 复制               | 退出插入模式(不检查缩写，不触发 InsertLeave) | 中断当前命令/搜索                   | 退出可视模式                               | 取消命令行                                       |
| Ctrl+d         | 复制;对比文件      | 删除当前行一个 shiftwidth 缩进               | 向下滚动'scroll'行(默认半屏)        | 向下滚动'scroll'行(默认半屏)               | 列出匹配光标前模式的补全                         |
| Ctrl+e         | 查看最近文件       | 插入光标下方字符                             | 向下滚动[count]行                   | 向下滚动[count]行                          | 光标移到命令行结尾                               |
| Ctrl+f         | 查找文本           | 无作用(但若在'cinkeys'中：重缩进当前行)      | 向下滚动[count]页                   | 向下滚动[count]页                          | 无特定作用                                       |
| Ctrl+g         | 跳到行列           | 无作用(但 Ctrl-G u：开始新可撤销编辑)        | 显示当前文件名和位置                | 切换到选择模式                             | 若'incsearch'活跃：跳到下一个匹配                |
| Ctrl+h         | 查看继承关系       | 删除光标前字符(同<BS>)                       | 左移[count]字符                     | 在选择模式：删除高亮区域                   | 删除光标前字符(同<BS>)                           |
| Ctrl+i         | 实现接口方法       | 插入<Tab>(同<Tab>)                           | 跳到跳转列表中第 N 个较新位置       | 跳到跳转列表中第 N 个较新位置              | 若'wildchar'为<Tab>：补全光标前模式              |
| Ctrl+j         | 插入模板代码       | 开始新行(同<CR>)                             | 下移[count]行(同 j)                 | 下移[count]行(同 j)                        | 无特定作用(但同<CR>：可能执行命令，如果映射)     |
| Ctrl+k         | 提交代码           | 输入二合字母(digraph)                        | 无特定作用                          | 无特定作用                                 | 输入二合字母(若'digraph'开启)                    |
| Ctrl+l         | 查找时跳到下一个   | 默认配置下无作用                             | 清除并重绘屏幕                      | 清除并重绘屏幕                             | 无特定作用(但若补全活跃：插入匹配的最长公共部分) |
| Ctrl+m         | 滚动到文件中间     | 开始新行(同<CR>)                             | 下移到非空字符(同<CR>)              | 下移到非空字符(同<CR>)                     | 执行命令(同<CR>)                                 |
| Ctrl+n         | 找类               | 查找下一个关键字补全                         | 下移[count]行                       | 无特定作用                                 | 下一条历史命令                                   |
| Ctrl+o         | 重写方法           | 执行一个命令，返回插入模式                   | 跳到跳转列表中第 N 个较旧位置       | 跳到跳转列表中第 N 个较旧位置              | 无特定作用(但'cedit'：打开命令窗口)              |
| Ctrl+p         | 查看方法参数信息   | 查找上一个关键字补全                         | 上移[count]行                       | 无特定作用                                 | 上一条历史命令                                   |
| Ctrl+q         | 查看快速文档       | 同 Ctrl+V：插入下一个非数字字面              | 无特定作用                          | 无特定作用                                 | 同 Ctrl+V：插入下一个非数字字面                  |
| Ctrl+r         | 替换文本           | 插入寄存器内容                               | 重做[count]次                       | 重做[count]次(选择模式:选删除文本的寄存器) | 插入寄存器内容                                   |
| Ctrl+s         | 保存全部           | 无作用                                       | 无特定作用                          | 无特定作用                                 | 无特定作用                                       |
| Ctrl+t         | 项目升级           | 插入一个 shiftwidth 缩进                     | 跳到标签列表中第 N 个较旧标签       | 跳到标签列表中第 N 个较旧标签              | 无作用                                           |
| Ctrl+u         | 跳父类方法         | 删除光标位置到行首所有字符                   | 向上滚动'scroll'行(默认半屏)        | 向上滚动'scroll'行(默认半屏)               | 删除光标位置到行首所有字符                       |
| Ctrl+v         | 粘贴               | 插入下一个非数字字面(或字节值)               | 开始块状可视模式                    | 开始块状可视模式                           | 插入下一个非数字字面                             |
| Ctrl+w         | 扩选文本           | 删除光标前单词(取决于'iskeyword')            | 窗口命令前缀(后接键，如 s 分割)     | 窗口命令前缀(后接键，如 s 分割)            | 删除光标前单词(取决于'iskeyword')                |
| Ctrl+x         | 剪切               | 进入补全子模式                               | 光标下或后的数字/字母减[count]      | 高亮文本中的数字/字母减[count]             | 无作用                                           |
| Ctrl+y         | 删除行             | 插入光标上方字符                             | 向上滚动[count]行                   | 向上滚动[count]行                          | 无特定作用                                       |
| Ctrl+z         | 撤销               | 无作用                                       | 挂起 Vim(或保存若'aw'设)            | 挂起 Vim                                   | 挂起 Vim                                         |

Linux 快捷键行为参考
| 快捷键         | 适用对象         | 功能描述                                                                  |
| -------------- | ---------------- | ------------------------------------------------------------------------- |
| Ctrl+\         | Linux 终端       | 发送 SIGQUIT 信号，强制退出 Vim 并可能生成核心转储（若终端未被 Vim 捕获） |
| Ctrl+C         | Linux 终端       | 发送 SIGINT 信号，中断当前进程（若 Vim 未捕获，可能终止 Vim）             |
| Ctrl+S         | Linux 终端       | 冻结终端输出（XOFF 流控制），暂停 Vim 显示（需 Ctrl+Q 恢复，XON）         |
| Ctrl+Q         | Linux 终端       | 恢复终端输出（XON 流控制），若 Ctrl+S 冻结则继续显示（可能无法映射）      |
| Ctrl+Z         | Linux 终端       | 发送 SIGTSTP 信号，挂起 Vim 进程（可通过 `fg` 恢复）                      |
| Ctrl+K         | Linux 终端/Shell | 删除到命令行尾（若终端捕获，可能覆盖 Vim 的二合字母输入功能）             |
| Ctrl+Delete    | 终端模拟器       | 删除到单词结尾（依赖终端配置，可能模拟 Vim 的 `diw` 行为）                |
| Ctrl+Backspace | 终端模拟器       | 删除到单词开头（依赖终端配置，可能模拟 Vim 的 `db` 或 `Ctrl+W` 行为）     |
