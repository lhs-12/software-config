--  See `:help vim.keymap.set()`
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>") -- See `:help hlsearch`
-- 在内置终端中更方便地退出终端模式. 注:此方法在终端模拟器/tmux不生效, 用<C-\><C-n>
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
-- 简化窗口跳转, 注意模拟终端按键冲突
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })