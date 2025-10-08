local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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
