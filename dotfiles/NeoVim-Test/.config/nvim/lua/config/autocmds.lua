-- see :help lua-guide-autocommands

-- 复制时高亮, See :help vim.hl.on_yank()
vim.api.nvim_set_hl(0, "YankHighlight", { bg = "#32593d", bold = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function() vim.hl.on_yank({ higroup = "YankHighlight", timeout = 350 }) end,
})
