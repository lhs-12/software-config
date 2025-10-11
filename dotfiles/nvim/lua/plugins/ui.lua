return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>ww", ":bdelete<CR>", desc = "Delete current Buffer" },
      { "<leader>wo", ":BufferLineCloseOthers<CR>", desc = "Delete other Buffer" },
      { "<S-h>", ":BufferLineCyclePrev<CR>", desc = "Prev Buffer" },
      { "<S-l>", ":BufferLineCycleNext<CR>", desc = "Next Buffer" },
    },
    opts = {},
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "LazyFile",
    opts = {
      extensions = {},
    },
  },
  {
    "nvim-mini/mini.diff",
    event = "VeryLazy",
    keys = {
      { "<leader>go", function() require("mini.diff").toggle_overlay(0) end, desc = "mini.diff overlay" },
    },
    opts = {
      view = { style = "sign" },
    },
  },
}
