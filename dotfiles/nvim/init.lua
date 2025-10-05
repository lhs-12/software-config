if vim.g.vscode then
  require("vscode-nvim")
  return
end
if vim.g.neovide then
  vim.o.guifont = "Maple Mono NF CN:h14"
end
require("config.lazy")