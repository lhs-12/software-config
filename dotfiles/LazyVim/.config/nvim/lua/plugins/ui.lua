return {
  {
    "folke/snacks.nvim",
    opts = {
      notifier = { timeout = 5000 },
      zen = { toggles = { dim = false }, win = { wo = { number = false } } },
      styles = {
        zen = { width = 120, backdrop = { transparent = false } },
        notification = { wo = { wrap = true } },
      },
    },
  },
  {
    "catgoose/nvim-colorizer.lua",
    event = "LazyFile",
    config = function()
      require("colorizer").setup({
        options = {
          parsers = {
            css = true, -- preset: enables names, hex, rgb, hsl, oklch, css_var
          },
        },
      })
    end,
  },
  {
    "Bekaboo/dropbar.nvim",
    event = "BufReadPre",
    config = function()
      local dropbar_api = require("dropbar.api")
      vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
      vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
      vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
    end,
  },
}
