if vim.g.vscode then
  require("vscode-nvim")
  return
end
if vim.g.neovide then
  vim.o.guifont = "Maple Mono Normal NL NF CN:h14"
end
-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
