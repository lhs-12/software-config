if vim.g.vscode then
  require("vscode-nvim")
  return
end
if vim.g.neovide then
  vim.o.guifont = "Maple Mono Normal NL NF CN:h14"
end

require("config.options")
require("config.lazy_bootstrap")
require("config.lazy_setup")
require("config.autocmds")
require("config.keymaps")