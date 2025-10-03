vim.api.nvim_set_hl(0, "VSCodeYankHighlight", { bg = "#32593d", bold = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "VSCodeYankHighlight", timeout = 350 })
  end,
})