local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  -- stylua: ignore
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.api.nvim_set_hl(0, "VSCodeYankHighlight", { bg = "#32593d", bold = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank({ higroup = "VSCodeYankHighlight", timeout = 350 }) end,
})

require("vscode-nvim.plugins")
require("vscode-nvim.keymaps")

if vim.uv.os_uname().sysname == "Linux" then
  vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
    vim.fn.system("fcitx5-remote -o") -- 打开输入法(转为英文)
    end,
  })
  vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
    vim.fn.system("fcitx5-remote -c") -- 关闭输入法(回到RIME)
    end,
  })
end

require("lazy").setup({
  spec = { { import = "vscode-nvim.plugins" } },
  defaults = { lazy = true, version = false },
  install = { missing = true },
  checker = { enabled = false },
  performance = {
    rtp = {
      -- stylua: ignore
      disabled_plugins = {
        "gzip", "matchit", "matchparen", "netrwPlugin",
        "tarPlugin", "tohtml", "tutor", "zipPlugin",
      },
    },
  },
})
