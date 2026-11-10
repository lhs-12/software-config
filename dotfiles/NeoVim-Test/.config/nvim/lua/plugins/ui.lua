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
    opts = {},
    config = function(_, opts)
      vim.o.showmode = false
      require('lualine').setup(opts)
    end
  },
}
