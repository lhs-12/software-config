-- Leader键
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
-- 关闭netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- Nerd字体可用
vim.g.have_nerd_font = true
-- Tab
vim.o.tabstop = 2 -- Tab显示宽度
vim.o.shiftwidth = 2 -- 缩进命令(<<,>>)使用空格数
vim.o.softtabstop = 2 -- 按Tab键时插入空格数/按删除时删除空格数
vim.o.expandtab = true -- 是否将Tab转为空格
vim.o.breakindent = true -- 换行后保留相同缩进
vim.o.backspace = "indent,eol,start" -- 退格键行为(删缩进)
-- 智能大小写搜索
vim.o.ignorecase = true -- 忽略大小写
vim.o.smartcase = true -- 智能大小写
-- 分割窗口打开方式
vim.o.splitbelow = true -- 向下开窗
vim.o.splitright = true -- 向右开窗
-- 列表模式: 不可见的空白字符显示为可见符号
vim.o.list = true -- 开启列表模式
vim.o.listchars = "tab:» ,trail:·,nbsp:␣" -- Tab/行尾空格/非断行空格
-- 行号
vim.o.number = true -- 是否显示行号
vim.o.relativenumber = false -- 是否显示相对行号
-- 折叠
vim.o.foldmethod = "indent" -- 基于缩进做折叠
vim.o.foldlevelstart = 99 -- 折叠级别99(全部展开)
-- vim文件
vim.o.autoread = true -- 自动读取文件变化
vim.o.swapfile = false -- 是否使用交换文件做备份
vim.o.undofile = false -- 是否持久化撤销历史
-- 弹出菜单
vim.o.completeopt = "menuone,noinsert,noselect,popup" -- 菜单行为
vim.o.wildmode = "list:longest,full" -- 补全行为(Tab)
vim.o.pumheight = 15 -- 弹出菜单高度
-- 外观
vim.o.colorcolumn = "120" -- 显示长度提示颜色列
vim.o.signcolumn = "auto" -- 左侧符号列自动打开, auto/no/yes
vim.o.wrap = false -- 是否开启自动换行
vim.o.timeoutlen = 1500 -- 键映射等待超时时间
vim.o.inccommand = "split" -- 替换命令时用分割窗口预览改变的项
vim.o.scrolloff = 5 -- 光标上下方保留的最小屏幕行数
-- vim.o.cursorline = true -- 加亮光标所在行
-- vim.o.confirm = true -- 操作可能丢失数据时(如:q)不报错, 而是显示对话框
-- grep行为
-- vim.o.grepprg = "rg --vimgrep --smart-case --hidden" -- rg替代grep
-- vim.o.grepformat = "%f:%l:%c:%m"                     -- 设置grep格式

-- MSYS2环境配置
if vim.env.MSYSTEM then
  -- 解决命令执行git相关命令报错
  vim.o.shellcmdflag = "-c"
  vim.o.shellxquote = ""
  -- 解决复制乱码(需要下载win32yank.exe到/usr/bin)
  vim.g.clipboard = {
    name = "win32yank",
    copy = {
      ["+"] = { "win32yank.exe", "-i", "--crlf" },
      ["*"] = { "win32yank.exe", "-i", "--crlf" },
    },
    paste = {
      ["+"] = { "win32yank.exe", "-o", "--lf" },
      ["*"] = { "win32yank.exe", "-o", "--lf" },
    },
    cache_enabled = 1,
  }
end
