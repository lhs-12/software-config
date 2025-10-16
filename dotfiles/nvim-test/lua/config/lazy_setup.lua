-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { import = "plugins" },
    -- { import = "lsp" },
  },
  default = { lazy = false, version = false },
  install = { colorscheme = { "bogster" } },
  checker = { enabled = false }, -- automatically check for plugin updates
})