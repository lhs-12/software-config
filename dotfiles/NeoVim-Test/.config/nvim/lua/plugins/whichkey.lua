return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix", -- classic/modern/helix
    spec = {
      {
        mode = { "n", "v" },
        { "<leader>a", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>e", group = "explorer" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>h", group = "git hunks" },
        { "<leader>q", group = "quit/session" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "ui" },
        { "<leader>w", group = "windows"},
        { "<leader>x", group = "diagnostics/quickfix" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "z", group = "fold" },
      },
    },
  },
  keys = {
    { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer Keymaps" },
    { "<c-w><space>", function() require("which-key").show({ keys = "<c-w>", loop = true }) end, desc = "Window Hydra Mode" },
  },
}
