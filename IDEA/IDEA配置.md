# <center>IDEA配置</center>

基于IDEA2022.3.3

# 插件

| 插件                                      |
| ----------------------------------------- |
| .ignore                                   |
| Alibaba Java Coding GuideLines            |
| Atom Material Icons                       |
| Private Notes                             |
| String Manipulation                       |
| GenerateAllSetter                         |
| GenerateSerialVersionUID                  |
| Git Flow Integration  Plus                |
| Ini                                       |
| Live Edit                                 |
| Maven Helper                              |
| Python                                    |
| Translation                               |
| CheckStyle-IDEA                           |
| MyBatisCodeHelperPro(Marketplace Edition) |

| Vim插件            |
| ------------------ |
| IdeaVim            |
| Which-Key          |
| IdeaVim-Quickscope |
| IdeaVim-EasyMotion |

# 设置
* Appearance & Behavior -> System Settings -> 取消 Reopen last project on startup
* Appearance & Behavior -> System Settings -> 配置Default project directory
* Editor -> File Types -> Ignore files中加入 `*.idea;*.iml;.mvn;.vscode;`
* Editor -> General -> 勾选 Change font size with Ctrl + Mouse Wheel
* Editor -> General -> Code Completion -> 取消Match case
* Editor -> General -> Code Folding -> Java -> 取消勾选One-line methods
* Editor -> General -> Auto Import -> Insert imports on paste选Always, 勾选 Add unambiguous....和Optimize import....
* Editor -> File Encodings -> 全部改UTF8, 勾选 Transparent native-to-ascii conversion
* Editor -> Code Style -> Line separator改为'Unix and macOS (\n)'
* Editor -> Code Style -> Hard Wrap at 的数量调180
* Editor -> Code Style -> Java -> Code Generation -> Comment Code -> 取消Line comment at first column,勾选下面的Add a space
* Editor -> Code Style -> Java -> Wrapping and Braces -> Method call arguments/Chain method calls/for() -> statement: Chop down if long
* Editor -> Code Style -> Java -> Wrapping and Braces -> Group declarations -> 勾选Align (fields 和 variables) in columns
* Version Control -> Git -> 检查Git配置
* Maven -> 配置settings.xml
* 项目的折叠: 点击Project那个位置的省略号,前几项不勾选
* File -> New Projects Settings -> Settings for New Projects -> 配置File Encodings
* File -> New Projects Settings -> Structure for New Projects -> 配置默认项目JDK
* Version Control -> Commit -> Before Commit 勾选 Optimize imports
* 暂时不用: Editor -> Editor Tabs -> 取消 Show tabs in one row

# 代码模板
Editor -> File and Code Templates -> includes -> FileHeader
```
/**
 * @author L
 */
```
Live Templates 添加Test组的test方法, 设置Abbreviation: test，Applicable: Java -> declaration
```
@Test
public void test$NAME$() {
    $END$
}
```

# 快捷键
* Close Others 改为 Ctrl Shift F4
* Down 加入 Ctrl j
* Up 加入 Ctrl k
* Vim 开关 改为 Ctrl Alt k

# 主题配置
步骤:
* 安装插件Material Theme UI Lite, 选择主题Arc Dark, 然后卸载该插件, 重启IDEA
* 安装插件Burnt Theme, 该主题底色为#1D1D1D
* Editor -> Color Scheme -> 换回Arc Dark主题, 然后开始配置

配置:
* Appearance & Behavior -> File Colors -> Test 改颜色(282828), Non-Project Files改为Green
* Editor -> Font -> Sarasa Mono SC Semibold  16 1.0
* Editor -> Color Scheme -> Console Font -> Sarasa Mono SC Semibold 14 1.0
* Editor -> Color Scheme -> General -> Text -> Default text -> Background: 1D1D1D
* Editor -> Color Scheme -> General -> Editor -> Gutter background -> Background: 1D1D1D
* Editor -> Color Scheme -> General -> Editor -> Caret row -> Background: 323232
* Editor -> Color Scheme -> General -> Errors and Warnings -> Unused symbol -> Foreground: 374747
* Editor -> Color Scheme -> General -> Popups and Hints -> Documentation -> Background: 323232
* Editor -> Color Scheme -> Console Colors -> Console -> Background: 1D1D1D
* Editor -> Color Scheme -> Language Defaults -> Template language -> Background: 282828
* Editor -> Color Scheme -> General -> Search Results -> Text Search Result -> Background: FBE71C
* Editor -> Color Scheme -> General -> Code -> Identifer开头的 -> 取消foreground/background,Error strip mark(4D6168)
* Editor -> Color Scheme -> Java -> 三种注释和Keyword都取消斜体

# IdeaVim配置
配置文件(~/.ideavimrc)

使用RIME输入法, 模式切换时变更输入法

从IDEA调用NeoVim打开当前文件, 配合neovide使用  
配置: Tools -> External Tools, 增加NeoVim选项配置
```
Program:            nvim
Arguments:          --wsl --frame none --maximized ./$FileName$
Working directory:  $FileDir$

取消勾选Open console for tool output
```

Vim快捷键冲突参考
| 冲突键 | idea               | vim                     |
| ------ | ------------------ | ----------------------- |
| Ctrl-2 | 去书签2            | 输入旧内容并退出i模式   |
| Ctrl-@ | 触发书签2          | 同上                    |
| Ctrl-6 | 去书签6            | 和上一个编辑的文件切换  |
| Ctrl-^ | 触发书签6          | 同上                    |
| Ctrl-a | 全选               | 计数器:加;写入旧的写入  |
| Ctrl-b | 去声明或使用处     | 向上翻页                |
| Ctrl-c | 复制               | 中断命令                |
| Ctrl-d | 复制;对比文件      | 下滚半页;减少缩进       |
| Ctrl-e | 查看最近文件       | 下滚行;从下一行抄写入   |
| Ctrl-f | 查找文本           | 向下翻页                |
| Ctrl-g | 跳到行列           | 显示文件路径            |
| Ctrl-h | 查看继承关系       | 退格                    |
| Ctrl-i | 实现接口方法       | 跳表往前                |
| Ctrl-j | 插入模板代码       | 滚动;新一行             |
| Ctrl-k | 提交代码           | 插入特殊二合字符        |
| Ctrl-l | 查找时跳到下一个   | 清屏                    |
| Ctrl-m | 滚动到文件中间     | 行首下滚                |
| Ctrl-o | 重写方法           | 跳到旧位置;临时执行命令 |
| Ctrl-r | 替换文本           | 粘贴(选择寄存器);重做   |
| Ctrl-t | 项目升级           | 跳tag;增加缩进          |
| Ctrl-u | 跳父类方法         | 上滚半页;删除到行首     |
| Ctrl-v | 粘贴               | 块状v模式               |
| Ctrl-w | 扩选文本           | 向前删词;窗口相关指令   |
| Ctrl-y | 删除行             | 上滚行;从上一行抄写入   |
| Ctrl-[ | 跳到附近大括号头部 | 退回normal模式          |
| Ctrl-\ | 文件选择列表根目录 | 用于某些不常用组合命令  |
| Ctrl-] | 跳到附近大括号尾部 | 跳到定义(同gd)          |
| Ctrl-n | 找类               | 代码提示(失效)          |
| Ctrl-p | 查看方法参数信息   | 代码提示                |
| Ctrl-q | 快速文档           | 无用                    |
| Ctrl-s | 保存全部           | 无                      |
| Ctrl-x | 剪切               | 计数器:减;代码提示相关  |