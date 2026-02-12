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
  -- 自动切换输入法, 要求使用 Fcitx5 + Rime
  -- 用busctl命令替代"fcitx5-remote -c/-o", 输入法设置就只需保留Rime了
  local rime_cmd_prefix = "busctl call --user org.fcitx.Fcitx5 /rime org.fcitx.Fcitx.Rime1 "
  vim.g.rime_was_ascii = true -- 记录输入法状态, 默认英文
  vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
      local result = vim.fn.system(rime_cmd_prefix .. "IsAsciiMode")
      local is_ascii = string.match(result, "b (%w+)") == "true"
      vim.g.rime_was_ascii = is_ascii
      if not is_ascii then
        vim.fn.system(rime_cmd_prefix .. "SetAsciiMode b true")
      end
    end,
  })
  vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
      if not vim.g.rime_was_ascii then
        vim.fn.system(rime_cmd_prefix .. "SetAsciiMode b false")
      end
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
