local vscode = require("vscode")
local m = vim.keymap.set
local opts = { noremap = true, silent = true }
m("n", "<esc>", "<cmd>noh<cr><esc>", opts)
m("n", "x", '"_x', opts)
m("n", "X", '"_X', opts)
m("n", "<C-q>", "<C-x>", opts)
m("n", "H", function() vscode.call("workbench.action.previousEditor") end)
m("n", "L", function() vscode.call("workbench.action.nextEditor") end)
m("n", "K", function() vscode.call("editor.action.showHover") end)
m("n", "cd", function() vscode.call("editor.action.rename") end)
m("n", "]d", function() vscode.action("editor.action.marker.next") end)
m("n", "[d", function() vscode.action("editor.action.marker.prev") end)
m("v", "<leader>w", function() vscode.call("editor.action.smartSelect.grow") end)
m("v", "<leader>W", function() vscode.call("editor.action.smartSelect.shrink") end)

m("n", "gf", function() vscode.call("workbench.action.gotoSymbol") end)
m("n", "gi", function() vscode.call("editor.action.goToImplementation") end)
m("n", "gp", function() vscode.call("workbench.explorer.fileView.focus") end)
m("n", "gy", function() vscode.call("editor.action.goToTypeDefinition") end)
m("n", "ge", function() vscode.call("remote-wsl.revealInExplorer") end)

m("n", "<leader>af", function() vscode.call("editor.action.organizeImports") vscode.call("editor.action.formatDocument") end)
m({ "n", "v" }, "<leader>ai", function() vscode.call("editor.action.quickFix") end)
m({ "n", "v" }, "<leader>ap", function() vscode.call("editor.action.showContextMenu") end)
m({ "n", "v" }, "<leader>ar", function() vscode.call("editor.action.refactor") end)

m("n", "<leader>db", function() vscode.call("editor.debug.action.toggleBreakpoint") end)

m("n", "<leader>mm", function() vscode.call("bookmarks.toggle") end)
m("n", "<leader>me", function() vscode.call("bookmarks.toggleLabeled") end)
m("n", "<leader>ms", function() vscode.call("bookmarks.listFromAllFiles") end)

m("n", "<leader>wp", function() vscode.call("workbench.action.toggleSidebarVisibility") end)
m("n", "<leader>wr", function() vscode.call("workbench.action.quickOpen") end)
m("n", "<leader>wo", function() vscode.call("workbench.action.closeOtherEditors") end)
m("n", "<leader>ww", function() vscode.call("workbench.action.closeActiveEditor") end)
m("n", "<leader>wz", function() vscode.call("workbench.action.toggleZenMode") end)
m("n", "<leader>wf", function() vscode.call("workbench.action.toggleFullScreen") end)
m("n", "<leader>wc", function() vscode.call("workbench.action.toggleCenteredLayout") end)

m("n", "<leader>t", function() vscode.call("workbench.action.terminal.newWithProfile") end)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    vim.keymap.set("n", "gs", function() vscode.call("java.action.navigateToSuperImplementation") end, { buffer = true })
  end,
})

local sys = vim.uv.os_uname().sysname:lower()
local config_dir
if sys:find("windows") or sys:find("mingw") or sys:find("msys") then
  config_dir = vim.fn.expand("$LOCALAPPDATA/nvim")
else
  config_dir = vim.fn.stdpath("config")
end
local keymaps_file = config_dir .. "/lua/vscode-nvim/keymaps.lua"
m("n", "<leader>?", function()
  vim.cmd("e " .. keymaps_file)
  vim.bo.modifiable = false
  vim.bo.readonly = true
end, opts)
