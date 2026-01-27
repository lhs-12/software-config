-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.o.swapfile = false
vim.o.undofile = false
vim.g.autoformat = true
vim.o.conceallevel = 0
vim.o.clipboard = ""

vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = "ruff"

-- MSYS2配置
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
