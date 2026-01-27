# Fish Shell 速查

## 查看配置

```bash
bind            # 列出所有绑定
fish_key_reader # 读取按键代码
fish_config     # 浏览器可视化配置
```

## Tab 补全

**按 Tab 触发智能补全**

```bash
# 路径补全
/priv<Tab>          # → /private/

# Git 分支补全
git checkout m<Tab> # 显示所有 m 开头的分支

# 命令选项补全
grep --i<Tab>       # → --ignore-case

# 文件名补全
cat file<Tab>       # 显示所有 file 开头的文件
```

**按 Tab 两次**：显示所有补全选项的交互列表

---

## 自动建议

**光标后显示灰色建议**，基于历史命令和补全

| 快捷键          | 功能                   |
| --------------- | ---------------------- |
| `→` 或 `Ctrl+F` | 接受整个建议           |
| `Alt+→`         | 接受建议的第一个单词   |
| `Ctrl+Space`    | 不接受建议，按字面输入 |

---

## 语法高亮

Fish 实时显示语法颜色，输入时即可验证

| 颜色   | 含义           |
| ------ | -------------- |
| 蓝色   | 有效命令       |
| 红色   | 无效命令或路径 |
| 下划线 | 有效文件路径   |
| 灰色   | 自动建议       |

---

## 历史搜索

### 搜索模式 1：上下箭头

```bash
git
# 按 ↑ 显示所有 git 开头的历史命令
# 按 ↓ 继续浏览
```

### 搜索模式 2：Ctrl+R

```bash
# 按 Ctrl+R 打开交互式历史搜索
# 输入关键词继续过滤, 再按 Ctrl+R/S 翻页
# 方向键选择，Enter 执行
```

### 搜索模式 3：Alt+↑

```bash
some_command git
# 光标放在 git 上，按 Alt+↑
# 搜索包含 git 的历史命令
```

### 不保存到历史

```bash
# 命令前加空格
secret-command  # 不会记录到历史

# 清除当前会话历史
history clear
```

---

## 常用组合键技巧

### 快速重复命令

```bash
# 输入命令前几个字符
git com<↑>       # 浏览所有 git com... 开头的历史
```

### 快速修改上一个命令

```bash
git commit -m "message"
# 按 ↑，然后 Alt+B 移动到 commit
# 修改为 push，回车执行
```

### 多行命令编辑

```bash
# 按 Alt+Enter 插入换行
for file in *.txt
    echo $file<Enter>
  end
```

---

## 通配符补全

```bash
# * 匹配任意字符；** 递归匹配
cat *.txt<Tab>   # 显示所有匹配的文件
**/*.log<Tab>    # 递归搜索所有 .log 文件
```

---

## 目录导航

```bash
# 目录历史
cd ~/Documents # 基本跳转
cd ../..       # 返回上两级目录

prevd # 返回上一个目录（类似后退） 默认绑定到 Alt+←
nextd # 前进到下一个目录 默认绑定到 Alt+→
dirh  # 查看目录历史栈
cdh   # 交互式选择目录历史

# 目录栈
pushd ~/Documents   # 保存当前目录并跳转
popd                # 返回到之前保存的目录
dirs                # 查看目录栈
```

---

## Bash / Fish 常见差异

### 退出状态

```bash
# Bash
echo $?  # 上一个命令的退出码
# Fish
echo $status
```

### 命令替换

```bash
# Bash (使用反引号或 $())
echo $(date)
echo `date`

# Fish (建议(), 兼容$(), 不支持反引号)
echo (date)
echo $(date)
```

### 设置变量

```bash
# Bash
VAR=value        # 设置变量
export VAR=value # 设置并导出
local VAR=value  # 局部变量（函数内）
unset VAR        # 删除变量

# Fish
set VAR value     # 设置变量 (不支持VAR=value)
set -gx VAR value # 全局并导出
set -l VAR value  # 局部变量
set -U VAR value  # 通用变量
set -e VAR        # 删除变量

# 临时环境变量(例外VAR=value)
# Bash/Fish 都支持
EDITOR=nvim env | grep EDITOR

# PATH 修改
export PATH="$HOME/bin:$PATH" # Bash
fish_add_path ~/.local/bin    # Fish(此方式可自动去重)
```

| 选项 | 长选项        | 说明                           |
| ---- | ------------- | ------------------------------ |
| `-l` | `--local`     | 局部变量（函数内默认）         |
| `-g` | `--global`    | 全局变量（当前会话）           |
| `-U` | `--universal` | 通用变量（永久存储，所有会话） |
| `-x` | `--export`    | 导出到环境变量                 |
| `-e` | `--erase`     | 删除变量                       |

### 别名

```bash
# Bash
alias ll='ls -lh'

# Fish
# 使用缩写，可以看到展开结果
# 不想展开的时候, 按 Ctrl + Space
abbr ll 'ls -lh'
# 或使用函数
function ll
  ls -lh $argv
end
```

### 历史展开

```bash
# Bash
!!       # 上一条命令
!$       # 上一条命令的最后一个参数
^old^new # 替换上一条命令中的 old 为 new

# Fish（使用快捷键替代）
# <Alt+.> # 上一条命令的最后一个参数
# <↑> 然后 <Ctrl+W> <Ctrl+Y>  # 编辑上一条命令
# 或使用自动建议
```

### 引号类型

| 类型   | Bash     | Fish    | 变量展开 |
| ------ | -------- | ------- | -------- |
| 双引号 | `"..."`  | `"..."` | 是       |
| 单引号 | `'...'`  | `'...'` | 否       |
| 转义   | `$'...'` | 不支持  | -        |

```bash
# Bash
echo $'\n\t' # 换行和制表符
# Fish
echo \n\t    # 转义序列在"未引用"时自动转换
echo "\n\t"  # 双引号中也有效
```

### 组合命令

```bash
# &&（and）- 前一个成功才执行下一个
./configure && make && sudo make install
# ||（or）- 前一个失败才执行下一个
command1 or command2
# !（not）- 取反
if not test -f file.txt
    echo "文件不存在"
end
# and/or 语句
cp file1 bak && cp file2 bak; and echo "备份成功"; or echo "备份失败"
```

---

## 快捷键

### 光标移动

| 快捷键    | 功能              |
| --------- | ----------------- |
| `Ctrl+A`  | 跳到行首          |
| `Ctrl+E`  | 跳到行尾          |
| `Alt+B/←` | 向左跳一个单词    |
| `Alt+F/→` | 向右跳一个单词    |
| `Ctrl+XX` | 跳到行首/行尾切换 |

### 编辑操作

| 快捷键   | 功能                           |
| -------- | ------------------------------ |
| `Ctrl+C` | 取消当前命令                   |
| `Ctrl+U` | 删除到行首                     |
| `Ctrl+K` | 删除到行尾                     |
| `Ctrl+W` | 删除前一个单词                 |
| `Alt+D`  | 删除后一个单词 ; 没词相当于pwd |
| `Ctrl+L` | 清屏（相当于 clear）           |
| `Alt+L`  | 相当于ls                       |

---
