-- Windows: %LOCALAPPDATA%/nvim/lua/vscode-nvim/init.lua
---@diagnostic disable-next-line: undefined-global
local vim = vim
vim.opt.ignorecase = true
vim.opt.smartcase = true
if not vim.g.vscode then return end
local vscode = require('vscode')
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
vim.g.mapleader = " "
keymap('n', '<esc>', '<cmd>noh<cr><esc>', opts)
keymap('n', 'x', '"_x', opts)
keymap('n', 'X', '"_X', opts)
keymap('n', '<C-q>', '<C-x>', opts)
keymap('n', 'H', function() vscode.call('workbench.action.previousEditor') end, opts)
keymap('n', 'L', function() vscode.call('workbench.action.nextEditor') end, opts)
keymap('n', 'K', function() vscode.call('editor.action.showHover') end, opts)
keymap('n', 'cd', function() vscode.call('editor.action.rename') end, opts)
keymap('v', '>', function() vscode.call('editor.action.indentLines') end, opts)
keymap('v', '<', function() vscode.call('editor.action.outdentLines') end, opts)
keymap('v', 'af', function() vscode.call('editor.action.smartSelect.grow') end, opts)
keymap('v', 'AF', function() vscode.call('editor.action.smartSelect.shrink') end, opts)

keymap('n', 'gf', function() vscode.call('workbench.action.gotoSymbol') end, opts)
keymap('n', 'gi', function() vscode.call('editor.action.goToImplementation') end, opts)
keymap('n', 'gp', function() vscode.call('workbench.explorer.fileView.focus') end, opts)
keymap('n', 'gy', function() vscode.call('editor.action.goToTypeDefinition') end, opts)
keymap('n', 'ge', function() vscode.call('remote-wsl.revealInExplorer') end, opts)

keymap('n', '<leader>af', function() vscode.call('editor.action.organizeImports') vscode.call('editor.action.formatDocument') end, opts)
keymap({'n', 'v'}, '<leader>ai', function() vscode.call('editor.action.quickFix') end, opts)
keymap({'n', 'v'}, '<leader>ap', function() vscode.call('editor.action.showContextMenu') end, opts)
keymap({'n', 'v'}, '<leader>ar', function() vscode.call('editor.action.refactor') end, opts)

keymap('n', '<leader>db', function() vscode.call('editor.debug.action.toggleBreakpoint') end, opts)

keymap('n', '<leader>mm', function() vscode.call('bookmarks.toggle') end, opts)
keymap('n', '<leader>me', function() vscode.call('bookmarks.toggleLabeled') end, opts)
keymap('n', '<leader>ms', function() vscode.call('bookmarks.listFromAllFiles') end, opts)

keymap('n', '<leader>wp', function() vscode.call('workbench.action.toggleSidebarVisibility') end, opts)
keymap('n', '<leader>wr', function() vscode.call('workbench.action.quickOpen') end, opts)
keymap('n', '<leader>wo', function() vscode.call('workbench.action.closeOtherEditors') end, opts)
keymap('n', '<leader>ww', function() vscode.call('workbench.action.closeActiveEditor') end, opts)
keymap('n', '<leader>wz', function() vscode.call('workbench.action.toggleZenMode') end, opts)
keymap('n', '<leader>wf', function() vscode.call('workbench.action.toggleFullScreen') end, opts)
keymap('n', '<leader>wc', function() vscode.call('workbench.action.toggleCenteredLayout') end, opts)
-- keymap('v', '<leader>wt', function() vscode.call('translation.translate') end, opts)

-- Java文件快捷键
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    vim.keymap.set('n', 'gs', function()
      vscode.call('java.action.navigateToSuperImplementation')
    end, { noremap = true, silent = true, buffer = true })
  end,
})
-- 查看配置文件
keymap('n', '<leader>?', function()
  vim.cmd("e $LOCALAPPDATA/nvim/lua/vscode-nvim/init.lua")
  vim.bo.modifiable = false
  vim.bo.readonly = true
end, opts)
-- 快速定位配置(s键)
local leap_path = vim.fn.stdpath("config") .. "/lua/vscode-nvim/leap.nvim"
if vim.fn.isdirectory(leap_path) == 0 then
  vim.fn.system({ "git", "clone", "--depth=1", "https://github.com/ggandor/leap.nvim.git", leap_path })
end
vim.opt.rtp:append(leap_path)
vim.keymap.set({ 'n', 'x', 'o' }, 's', function()
  local winid = vim.api.nvim_get_current_win()
  local c1 = vim.fn.getcharstr()
  local c2 = vim.fn.getcharstr()
  if c1 == ' ' and c2 == ' ' then -- s<space><space> leap line
    local targets = {}
    local winid = vim.api.nvim_get_current_win()
    local wininfo = vim.fn.getwininfo(winid)[1]
    local lnum = wininfo.topline
    while lnum <= wininfo.botline do
      table.insert(targets, { pos = { lnum, 1 }, winid = winid })
      lnum = lnum + 1
    end
    require('leap').leap { targets = targets, target_windows = { winid } }
  else -- s<char1><char2> leap char1
    vim.api.nvim_feedkeys(c1 .. c2, 'n', false)
    require('leap').leap({ target_windows = { winid } })
  end
end)
-- 中文分词跳转配置
local jieba_lua_path = vim.fn.stdpath("config") .. "/lua/vscode-nvim/jieba-lua"
local jieba_nvim_path = vim.fn.stdpath("config") .. "/lua/vscode-nvim/jieba.nvim"
if vim.fn.isdirectory(jieba_lua_path) == 0 then
  vim.fn.system({ "git", "clone", "--depth=1", "https://github.com/noearc/jieba-lua.git", jieba_lua_path })
end
if vim.fn.isdirectory(jieba_nvim_path) == 0 then
  vim.fn.system({ "git", "clone", "--depth=1", "https://github.com/neo451/jieba.nvim", jieba_nvim_path })
end
vim.opt.rtp:append(jieba_lua_path)
vim.opt.rtp:append(jieba_nvim_path)
require("jieba_nvim").setup()