-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local function augroup(name) return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true }) end
vim.api.nvim_set_hl(0, "YankHighlight", { bg = "#32593d", bold = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function() (vim.hl or vim.highlight).on_yank({ higroup = "YankHighlight", timeout = 350 }) end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "markdown", "text" },
  callback = function() vim.opt_local.spell = false end,
})

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
