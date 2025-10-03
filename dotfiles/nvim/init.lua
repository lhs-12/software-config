-- Windows: %LOCALAPPDATA%/nvim/init.lua

if vim.g.neovide then
  vim.o.guifont = "Maple Mono NF CN:h14"
end

if vim.g.vscode then
  require("vscode-nvim")
  return
end