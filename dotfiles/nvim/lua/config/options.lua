-- 关闭netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " " -- Leader Key
vim.g.maplocalleader = "\\" -- Local Leader Key
vim.g.have_nerd_font = true -- Nerd字体可用
vim.o.number = true -- 显示行号
vim.o.showmode = false -- 不显示模式, 用状态栏代替
vim.o.breakindent = true -- 启用断行缩进
vim.o.undofile = false -- 不保存撤销历史
vim.o.signcolumn = "auto" -- 符号列自动打开, auto/no/yes
vim.o.updatetime = 3000 -- 保存交换文件的频率(毫秒)
vim.o.timeoutlen = 1500 -- 键映射等待超时时间
-- 智能大小写搜索
vim.o.ignorecase = true
vim.o.smartcase = true
-- 分割窗口打开方式
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.o.list = true -- 列表模式: 不可见的空白字符显示为可见符号
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" } -- Tab/行尾空格/非断行空格
vim.o.inccommand = "split" -- 替换命令时用分割窗口预览改变的项
-- vim.o.confirm = true -- 操作可能丢失数据时(如:q)不报错, 而是显示对话框
-- vim.o.cursorline = true -- 加亮光标所在行
vim.o.scrolloff = 5 -- 光标上下方保留的最小屏幕行数

-- MSYS2环境配置
if vim.env.MSYSTEM then
  -- 解决命令执行git相关命令报错
  vim.opt.shellcmdflag = "-c"
  vim.opt.shellxquote = ""
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