# <center>IDEA配置</center>

基于 IDEA2022.3.3

# 插件

```shell
idea64.exe installPlugins ^
mobi.hsz.idea.gitignore ^                                   # .ignore
com.jetbrains.plugins.ini4idea ^                            # Ini
ru.adelf.idea.dotenv ^                                      # .env files support
com.mallowigi ^                                             # Atom Material Icons
TheBlind.privateNotes ^                                     # Private Notes
com.bruce.intellijplugin.generatesetter ^                   # GenerateAllSetter
GenerateSerialVersionUID ^                                  # GenerateSerialVersionUID
com.ccnode.codegenerator.MyBatisCodeHelperProMarketPlace ^  # MyBatisCodeHelperPro(Marketplace Edition)
MavenRunHelper ^                                            # Maven Helper
cn.yiiguxing.plugin.translate ^                             # Translation
com.alibaba.p3c.xenoamess ^                                 # Alibaba Java Coding Guidelines
CheckStyle-IDEA ^                                           # CheckStyle-IDEA
com.intellij.plugins.html.instantEditing ^                  # Live Edit
Pythonid ^                                                  # Python
IdeaVIM ^                                                   # IdeaVim
eu.theblob42.idea.whichkey ^                                # Which-Key
com.joshestein.ideavim-quickscope ^                         # IdeaVim-Quickscope
org.jetbrains.IdeaVim-EasyMotion ^                          # IdeaVim-EasyMotion
AceJump ^                                                   # AceJump

# 对以上内容使用vi命令编辑, 并执行编辑后的结果. 命令:%s/\^.*/^/

# 其他
# Big Data Tools 系列插件
# Spring系列相关插件, 搜 /vendor:"JetBrains s.r.o." Spring
# String Manipulation
# Material Theme UI Lite
# Burnt Theme
```

# 快捷键

-   Close Others Tabs 改为 Ctrl Shift F4
-   Vim 开关 改为 Ctrl Alt k

# 设置

-   Appearance & Behavior -> System Settings -> 取消 Reopen last project on startup
-   Appearance & Behavior -> System Settings -> 配置 Default project directory
-   Editor -> File Types -> Ignore files 中加入 `*.idea;*.iml;.mvn;.vscode;`
-   Editor -> General -> 勾选 Change font size with Ctrl + Mouse Wheel
-   Editor -> General -> Code Completion -> 取消 Match case
-   Editor -> General -> Code Folding -> Java -> 取消勾选 One-line methods
-   Editor -> General -> Auto Import -> Insert imports on paste 选 Always, 勾选 Add unambiguous....和 Optimize import....
-   Editor -> File Encodings -> 全部改 UTF8, 勾选 Transparent native-to-ascii conversion
-   Editor -> Code Style -> Line separator 改为'Unix and macOS (\n)'
-   Editor -> Code Style -> Hard Wrap at 的数量调 180
-   Editor -> Code Style -> Java -> Code Generation -> Comment Code -> 取消 Line comment at first column,勾选下面的 Add a space
-   Editor -> Code Style -> Java -> Wrapping and Braces -> Method call arguments/Chain method calls/for() -> statement: Chop down if long
-   Editor -> Code Style -> Java -> Wrapping and Braces -> Group declarations -> 勾选 Align (fields 和 variables) in columns
-   Version Control -> Git -> 检查 Git 配置
-   Maven -> 配置 settings.xml
-   项目的折叠: 点击 Project 那个位置的省略号,前几项不勾选
-   File -> New Projects Settings -> Settings for New Projects -> 配置 File Encodings
-   File -> New Projects Settings -> Structure for New Projects -> 配置默认项目 JDK
-   Version Control -> Commit -> Before Commit 勾选 Optimize imports
-   暂时不用: Editor -> Editor Tabs -> 取消 Show tabs in one row

# 代码模板

Editor -> File and Code Templates -> includes -> FileHeader
```
/**
 * @author L
 */
```

Live Templates 添加 Test 组的 test 方法, 设置 Abbreviation: test, Applicable: Java -> declaration
```
@Test
public void test$NAME$() {
    $END$
}
```

# 主题配置

步骤:
-   安装插件 Material Theme UI Lite, 选择主题 Arc Dark, 然后卸载该插件, 重启 IDEA
-   安装插件 Burnt Theme, 该主题底色为#1D1D1D
-   Editor -> Color Scheme -> 换回 Arc Dark 主题, 然后开始配置

配置:
-   Appearance & Behavior -> File Colors -> Test 改颜色(282828), Non-Project Files 改为 Green
-   Editor -> Font -> Sarasa Mono SC Semibold 16 1.0
-   Editor -> Color Scheme -> Console Font -> Sarasa Mono SC Semibold 14 1.0
-   Editor -> Color Scheme -> General -> Text -> Default text -> Background: 1D1D1D
-   Editor -> Color Scheme -> General -> Editor -> Gutter background -> Background: 1D1D1D
-   Editor -> Color Scheme -> General -> Editor -> Caret row -> Background: 323232
-   Editor -> Color Scheme -> General -> Errors and Warnings -> Unused symbol -> Foreground: 374747
-   Editor -> Color Scheme -> General -> Popups and Hints -> Documentation -> Background: 323232
-   Editor -> Color Scheme -> Console Colors -> Console -> Background: 1D1D1D
-   Editor -> Color Scheme -> Language Defaults -> Template language -> Background: 282828
-   Editor -> Color Scheme -> General -> Search Results -> Text Search Result -> Background: FBE71C
-   Editor -> Color Scheme -> General -> Code -> Identifer 开头的 -> 取消 foreground/background,Error strip mark(4D6168)
-   Editor -> Color Scheme -> Java -> 三种注释和 Keyword 都取消斜体

# IdeaVim 配置

配置文件(~/.ideavimrc)

使用 RIME 输入法, 模式切换时变更输入法

从 IDEA 调用 NeoVim 打开当前文件, 配合 neovide 使用  
配置: Tools -> External Tools, 增加 NeoVim 选项配置

```
Program:            nvim
Arguments:          --wsl --frame none --maximized ./$FileName$
Working directory:  $FileDir$

取消勾选Open console for tool output
```

Vim 快捷键冲突及功能参考
| 快捷键 | IDEA功能           | Insert模式                     | Normal模式                   | Visual模式               | Command-line模式   |
| ------ | ------------------ | ------------------------------ | ---------------------------- | ------------------------ | ------------------ |
| Ctrl+2 | 去书签 2           | 通常等同于Ctrl+@               | 通常等同于Ctrl+@             | 无特定作用               | 无作用             |
| Ctrl+@ | 触发书签 2         | 插入上次插入的文本并停止插入   | 插入上次插入的文本并停止插入 | 无特定作用               | 无作用             |
| Ctrl+6 | 去书签 6           | 无作用                         | 切换到另一个缓冲区           | 切换到另一个缓冲区       | 无作用             |
| Ctrl+^ | 触发书签 6         | 无作用                         | 切换到另一个缓冲区           | 切换到另一个缓冲区       | 无作用             |
| Ctrl+[ | 跳到附近大括号头部 | 退出Insert模式                 | 同Esc键, 退出当前模式        | 退出Visual模式           | 取消命令行         |
| Ctrl+] | 跳到附近大括号尾部 | 无作用                         | 跳转到光标下标识符的定义处   | 跳转到选中标识符的定义处 | 无作用             |
| Ctrl+\ | 文件选择列表根目录 | 无作用                         | 无特定作用                   | 无特定作用               | 无作用             |
| Ctrl+a | 全选               | 插入上次插入的文本             | 将光标下的数字加1            | 选中所有文本             | 移动到行首         |
| Ctrl+b | 去声明或使用处     | 无作用                         | 向上滚动一页                 | 向上滚动一页             | 向左移动一个字符   |
| Ctrl+c | 复制               | 退出Insert模式,同Esc           | 中断当前操作                 | 退出Visual模式           | 取消命令行         |
| Ctrl+d | 复制;对比文件      | 减少当前行缩进                 | 向下滚动半页                 | 向下滚动半页             | 显示可能的补全列表 |
| Ctrl+e | 查看最近文件       | 插入下一行相同列的字符         | 向下滚动一行                 | 向下滚动一行             | 向右移动光标到行尾 |
| Ctrl+f | 查找文本           | 无作用                         | 向下滚动一页                 | 向下滚动一页             | 向右移动一个字符   |
| Ctrl+g | 跳到行列           | 无作用                         | 显示文件信息                 | 显示文件信息             | 无作用             |
| Ctrl+h | 查看继承关系       | 删除前一个字符(同退格键)       | 同退格键                     | 同退格键                 | 删除前一个字符     |
| Ctrl+i | 实现接口方法       | 插入制表符                     | 跳转到较新的跳转位置         | 跳转到较新的跳转位置     | 补全命令           |
| Ctrl+j | 插入模板代码       | 开始新行                       | 同Enter键                    | 同Enter键                | 执行命令           |
| Ctrl+k | 提交代码           | 输入digraph                    | 无作用                       | 无作用                   | 删除到行尾         |
| Ctrl+l | 查找时跳到下一个   | 无作用                         | 重绘屏幕                     | 重绘屏幕                 | 补全命令行         |
| Ctrl+m | 滚动到文件中间     | 开始新行                       | 同Enter键                    | 同Enter键                | 执行命令           |
| Ctrl+n | 找类               | 自动补全(下一个)               | 向下查找下一个匹配           | 无作用                   | 下一条命令历史     |
| Ctrl+o | 重写方法           | 临时退出Insert模式执行一个命令 | 跳转到较旧的跳转位置         | 跳转到较旧的跳转位置     | 执行命令并返回     |
| Ctrl+p | 查看方法参数信息   | 自动补全(上一个)               | 向上查找上一个匹配           | 无作用                   | 上一条命令历史     |
| Ctrl+q | 查看快速文档       | 同Ctrl+V                       | 无作用(或开始可视块模式)     | 无作用                   | 无作用             |
| Ctrl+r | 替换文本           | 插入寄存器内容                 | 重做                         | 重做                     | 插入寄存器内容     |
| Ctrl+s | 保存全部           | 无作用                         | 无作用(或冻结终端)           | 无作用                   | 无作用             |
| Ctrl+t | 项目升级           | 增加当前行缩进                 | 跳转到较旧的标签位置         | 跳转到较旧的标签位置     | 无作用             |
| Ctrl+u | 跳父类方法         | 删除当前行到行首的内容         | 向上滚动半页                 | 向上滚动半页             | 删除到行首         |
| Ctrl+v | 粘贴               | 插入字符的字面值               | 开始可视块模式               | 切换到可视块模式         | 插入字符的字面值   |
| Ctrl+w | 扩选文本           | 删除前一个单词                 | 窗口组合指令                 | 窗口组合指令             | 删除前一个单词     |
| Ctrl+x | 剪切               | 开始自动补全                   | 将光标下的数字减1            | 无作用                   | 无作用             |
| Ctrl+y | 删除行             | 插入上一行相同列的字符         | 向上滚动一行                 | 向上滚动一行             | 粘贴之前删除的文本 |

无冲突快捷键功能参考
| 快捷键         | IDEA功能     | Insert模式         | Normal模式         | Visual模式             | Command-line模式   |
| -------------- | ------------ | ------------------ | ------------------ | ---------------------- | ------------------ |
| Ctrl+z         | 撤销         | 无作用             | 挂起Vim            | 挂起Vim                | 挂起Vim            |
| Ctrl+↑         | 向上滚动     | 无作用             | 向上滚动一行       | 向上滚动一行           | 查看上一条命令历史 |
| Ctrl+↓         | 向下滚动     | 无作用             | 向下滚动一行       | 向下滚动一行           | 查看下一条命令历史 |
| Ctrl+←         | 向左跳转单词 | 向左跳转一个单词   | 向左跳转一个单词   | 向左扩展选择一个单词   | 向左移动一个单词   |
| Ctrl+→         | 向右跳转单词 | 向右跳转一个单词   | 向右跳转一个单词   | 向右扩展选择一个单词   | 向右移动一个单词   |
| Ctrl+Delete    | 向后删除单词 | 删除光标到单词结尾 | 删除光标到单词结尾 | 删除选中文本到单词结尾 | 删除光标到单词结尾 |
| Ctrl+Backspace | 向前删除单词 | 删除光标到单词开头 | 删除光标到单词开头 | 删除选中文本到单词开头 | 删除光标到单词开头 |
| Ctrl+/         | 注释         | 无作用             | 通常等同于Ctrl+    | 通常等同于Ctrl+        | 无作用             |